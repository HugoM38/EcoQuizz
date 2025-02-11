import 'package:ecoquizz/ui/widgets/ecoquizz_appbar.dart';
import 'package:ecoquizz/ui/widgets/ecoquizz_button.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int totalImpact;

  const ResultPage({super.key, required this.totalImpact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EcoQuizzAppBar(
        title: "Ton Résultat",
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade300, Colors.green.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.eco,
                      color: Colors.green,
                      size: 80,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Ton taux de CO₂ est :',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$totalImpact kg',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Bravo pour tes efforts pour réduire ton empreinte carbone !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 30),
                    EcoQuizzButton(
                      title: "Terminer",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
