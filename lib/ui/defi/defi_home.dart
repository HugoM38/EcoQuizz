import 'package:ecoquizz/models/question.dart';
import 'package:ecoquizz/services/quiz_service.dart';
import 'package:ecoquizz/ui/quiz/quiz_page.dart';
import 'package:ecoquizz/ui/widgets/EcoQuizz_appbar.dart';
import 'package:flutter/material.dart';
import 'package:ecoquizz/services/defi_service.dart';
import 'package:ecoquizz/models/defi_model.dart';
import 'package:ecoquizz/utils/shared_prefs_manager.dart';

class DefiPage extends StatefulWidget {
  const DefiPage({Key? key}) : super(key: key);

  @override
  State<DefiPage> createState() => _DefiPageState();
}

class _DefiPageState extends State<DefiPage> {
  final DefiService _defiService = DefiService();

  List<Defi> _defis = [];
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final userId = await SharedPreferencesManager.getUser();
      if (userId == null) throw "Aucun utilisateur connecté.";

      final allDefis = await _defiService.fetchAllDefis();

      final userDefis = await _defiService.fetchLastTimeDone(userId);

      final userMap = {for (final d in userDefis) d.id: d};
      final merged = <Defi>[];

      for (final d in allDefis) {
        if (userMap.containsKey(d.id)) {
          final userDefi = userMap[d.id]!;
          merged.add(d.copyWith(lastDate: userDefi.lastDate));
        } else {
          merged.add(d);
        }
      }

      setState(() {
        _defis = merged;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = "$e";
        _isLoading = false;
      });
    }
  }

  Future<void> _validerDefi(Defi defi) async {
    try {
      final userId = await SharedPreferencesManager.getUser();
      if (userId == null) throw "Aucun utilisateur connecté.";
      await _defiService.updateHistory(userId, defi.id);
      await _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Défi '${defi.titre}' validé !")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  void startQuiz() async {
    List<Question> questions = await QuizService().fetchQuestions();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QuizPage(questions: questions)));
  }

  Widget _buildContent() {
    if (_defis.isEmpty) {
      return Center(
        child: Text(
          "Aucun défi disponible.",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    final nowLocal = DateTime.now();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            "Défis quotidiens",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _defis.length,
            itemBuilder: (context, index) {
              final defi = _defis[index];
              bool isBlocked = false;

              if (!defi.unlimited && defi.lastDate != null) {
                final localLastDate = defi.lastDate!.toLocal();
                if (isSameDay(localLastDate, nowLocal)) {
                  isBlocked = true;
                }
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: defi.unlimited
                                ? const Icon(
                                    Icons.all_inclusive,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "1x",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                defi.titre,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                defi.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Impact : ${defi.impact}",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (defi.lastDate != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "Dernière validation : ${defi.lastDate!.toLocal()}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onPressed:
                              isBlocked ? null : () => _validerDefi(defi),
                          child: Text(
                            isBlocked ? "Bloqué (aujourd'hui)" : "Valider",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EcoQuizzAppBar(title: "EcoQuizz"),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMsg != null
              ? Center(
                  child: Text(
                    "Erreur : $_errorMsg",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                )
              : _buildContent(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: startQuiz,
        child: const Icon(Icons.quiz),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
