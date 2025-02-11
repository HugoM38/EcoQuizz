import 'package:ecoquizz/services/user_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DefiHistoryChart extends StatelessWidget {
  const DefiHistoryChart({super.key});

  DateTime parseDate(dynamic rawDate) {
    if (rawDate is String) {
      return DateTime.parse(rawDate);
    } else if (rawDate is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    return FutureBuilder<List<dynamic>>(
      future: userService.fetchUserDefiHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Aucun défi disponible"));
        } else {
          List<dynamic> defiHistory = snapshot.data!;
          DateTime now = DateTime.now();
          DateTime tenDaysAgo = now.subtract(const Duration(days: 10));
          List<dynamic> filtered = defiHistory.where((item) {
            DateTime date = parseDate(item["date"]);
            return date.isAfter(tenDaysAgo);
          }).toList();

          Map<String, double> dailyImpact = {};
          for (var item in filtered) {
            DateTime date = parseDate(item["date"]);
            String key = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
            double impact = (item["defi"]["impact"] as num).toDouble();
            dailyImpact.update(key, (value) => value + impact, ifAbsent: () => impact);
          }
          List<String> sortedKeys = dailyImpact.keys.toList()
            ..sort((a, b) {
              DateTime da = DateTime.parse(a);
              DateTime db = DateTime.parse(b);
              return da.compareTo(db);
            });
          List<BarChartGroupData> barGroups = [];
          for (int i = 0; i < sortedKeys.length; i++) {
            double y = dailyImpact[sortedKeys[i]]!;
            barGroups.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(toY: y, color: Colors.blue, width: 16),
                ],
              ),
            );
          }
          
          return BarChart(
            BarChartData(
              barGroups: barGroups,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= sortedKeys.length) return const SizedBox();
                      DateTime date = DateTime.parse(sortedKeys[index]);
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
