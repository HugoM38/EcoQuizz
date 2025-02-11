import 'package:flutter/material.dart';
import 'package:ecoquizz/ui/widgets/EcoQuizz_appbar.dart';

class DefiPage extends StatefulWidget {
  const DefiPage({Key? key}) : super(key: key);

  @override
  State<DefiPage> createState() => _DefiPageState();
}

class _DefiPageState extends State<DefiPage> {
  final Set<String> _validatedDefis = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EcoQuizzAppBar(title: "EcoQuizz"),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 1), () {
          // Exemple de données mockées
          return [
            {
              "id": "1",
              "titre": "Supprimer 100 e-mails inutiles",
              "description": "Efface 100 mails pour soulager ta boîte",
              "impact": -10,
              "unlimited": false
            },
            {
              "id": "2",
              "titre": "Baisser la résolution vidéo en 720p",
              "description": "Réduis la consommation de bande passante",
              "impact": -15,
              "unlimited": false
            },
            {
              "id": "3",
              "titre": "Désactiver Wi-Fi/Bluetooth inactifs",
              "description": "Réduis la consommation d’énergie",
              "impact": -5,
              "unlimited": true
            },
          ];
        }),
        builder: (context, snapshot) {
          // 1) Chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2) Erreur
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur : ${snapshot.error}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }

          // 3) Aucune donnée
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Text(
                "Aucun défi disponible pour le moment.",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }

          // 4) Affichage normal
          final defis = snapshot.data as List;
          return Column(
            children: [
              // Titre "Défis quotidiens"
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
                  itemCount: defis.length,
                  itemBuilder: (context, index) {
                    final defi = defis[index];
                    final defiId = defi["id"] as String;
                    final bool isUnlimited = defi["unlimited"] as bool;
                    final bool isAlreadyValidated =
                    _validatedDefis.contains(defiId);

                    return Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                              // Icône ou tag "∞" si illimité, sinon un tag "1x"
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                                  child: isUnlimited
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

                              // Espace principal : titre + description + impact
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Titre
                                    Text(
                                      defi["titre"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Description
                                    Text(
                                      defi["description"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Impact
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
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "Impact : ${defi["impact"]}",
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
                                  ],
                                ),
                              ),

                              // Bouton Valider
                              const SizedBox(width: 8),
                              Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    onPressed: isUnlimited
                                        ? () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Défi '${defi["titre"]}' validé (unlimited) !"),
                                          behavior:
                                          SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                        : isAlreadyValidated
                                        ? null
                                        : () {
                                      setState(() {
                                        _validatedDefis.add(defiId);
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Défi '${defi["titre"]}' validé !"),
                                          behavior: SnackBarBehavior
                                              .floating,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      isUnlimited
                                          ? "Valider"
                                          : isAlreadyValidated
                                          ? "Déjà validé"
                                          : "Valider",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
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
        },
      ),
    );
  }
}
