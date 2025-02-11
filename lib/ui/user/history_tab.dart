import 'package:flutter/material.dart';
import 'package:ecoquizz/services/user_service.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  late Future<List<dynamic>> _historyFuture;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _historyFuture = _userService.fetchUserDefiHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Aucun historique de défis disponible"));
        } else {
          final history = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              DateTime date = DateTime.parse(item["date"]);
              String formattedDate = "${date.day}/${date.month}/${date.year}";
              final defi = item["defi"];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text(defi["titre"] ?? "Défi inconnu"),
                  subtitle: Text(
                    "${defi["description"] ?? ""}\nImpact: ${defi["impact"]} kg CO₂",
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
