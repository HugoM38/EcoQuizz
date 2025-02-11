import 'dart:async';
import 'package:ecoquizz/models/defi_model.dart';

class DefiService {
  // Fonction simulant un appel à une API pour récupérer une liste de défis.
  // Pour l’instant, on se contente d’un délai simulé + liste mockée.
  Future<List<Defi>> fetchDefis() async {
    await Future.delayed(const Duration(seconds: 2));

    // Liste de défis “mock”
    return [
      Defi(
        id: 1,
        titre: "Supprimer 100 e-mails inutiles",
        description:
        "Efface 100 messages non essentiels pour réduire l'encombrement numérique",
        impact: -10,
      ),
      Defi(
        id: 2,
        titre: "Baisser la résolution des vidéos en 720p",
        description:
        "Réduis la consommation de bande passante en évitant la HD inutile",
        impact: -15,
      ),
      Defi(
        id: 3,
        titre: "Désactiver le Wi-Fi et le Bluetooth quand inactifs",
        description:
        "Réduis la consommation d’énergie en désactivant les connexions inutilisées",
        impact: -5,
      ),
      Defi(
        id: 4,
        titre: "Activer le mode sombre sur smartphone",
        description:
        "Diminue l’empreinte énergétique, surtout sur les écrans OLED/AMOLED",
        impact: -7,
      ),
      Defi(
        id: 5,
        titre: "Transférer un fichier localement plutôt que via le cloud",
        description:
        "Utilise un câble ou un partage local pour éviter l’envoi sur des serveurs distants",
        impact: -3,
      ),
      Defi(
        id: 6,
        titre: "Choisir un moteur de recherche écologique",
        description:
        "Privilégie des services qui compensent les émissions de CO₂",
        impact: -4,
      ),
      Defi(
        id: 7,
        titre: "Limiter le streaming à un réseau Wi-Fi domestique",
        description:
        "Évite la data mobile pour réduire l'empreinte carbone et télécharge si possible",
        impact: -6,
      ),
    ];
  }
}
