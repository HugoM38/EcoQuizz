import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int totalImpact;

  const ResultPage({super.key, required this.totalImpact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultat'),
      ),
      body: Center(
        child: Text(
          'Ton taux de CO2 est: $totalImpact',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}