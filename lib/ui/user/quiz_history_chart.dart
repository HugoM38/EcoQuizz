import 'package:ecoquizz/services/user_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class QuizHistoryChart extends StatelessWidget {
  const QuizHistoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    return FutureBuilder<List<dynamic>>(
      future: userService.fetchUserQuizHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Aucune donnée de quiz disponible"));
        } else {
          List<dynamic> history = snapshot.data!;
          // Trier par date (on suppose que "date" est en millisecondes)
          history.sort((a, b) => a["date"].compareTo(b["date"]));
          // Garder les 10 derniers éléments
          final last10 = history.length > 10 ? history.sublist(history.length - 10) : history;
          
          // Construire les points du graphique
          List<FlSpot> spots = [];
          for (int i = 0; i < last10.length; i++) {
            double x = i.toDouble();
            double y = (last10[i]["impact"] as num).toDouble();
            spots.add(FlSpot(x, y));
          }
          
          return LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                )
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= last10.length) return const SizedBox();
                      DateTime date = DateTime.parse(last10[index]["date"]);
                      String formatted = "${date.day}/${date.month}";
                      return Text(formatted, style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toString(), style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
