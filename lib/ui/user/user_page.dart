import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemple fl_chart',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const UserPage(),
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // 0: Statistiques, 1: Historique
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Boutons pour changer d'onglet
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentTabIndex = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentTabIndex == 0 ? Colors.green : Colors.grey,
                  ),
                  child: const Text("Statistiques"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentTabIndex = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentTabIndex == 1 ? Colors.green : Colors.grey,
                  ),
                  child: const Text("Historique"),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentTabIndex == 0 ? _buildStatsTab() : _buildHistoryTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistiques CO₂ & Utilisation",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Graphique linéaire avec fl_chart
          Container(
            height: 200,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
            ),
            child: const SimpleLineChart(),
          ),
          const SizedBox(height: 24),
          // Graphique en barres avec fl_chart
          Container(
            height: 200,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
            ),
            child: const SimpleBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    // Exemple de données fictives pour l'historique des défis
    final List<Map<String, String>> history = [
      {"title": "Défi de la semaine", "date": "2023-12-01", "status": "Réussi"},
      {"title": "Défi quotidien", "date": "2023-12-02", "status": "Échoué"},
      {"title": "Défi environnemental", "date": "2023-12-03", "status": "Réussi"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(
              item["status"] == "Réussi" ? Icons.check_circle : Icons.cancel,
              color: item["status"] == "Réussi" ? Colors.green : Colors.red,
            ),
            title: Text(item["title"]!),
            subtitle: Text(item["date"]!),
            trailing: Text(item["status"]!),
          ),
        );
      },
    );
  }
}

/// Graphique linéaire utilisant fl_chart
class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 4,
        minY: 1,
        maxY: 3,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = '1 déc';
                    break;
                  case 1:
                    text = '2 déc';
                    break;
                  case 2:
                    text = '3 déc';
                    break;
                  case 3:
                    text = '4 déc';
                    break;
                  case 4:
                    text = '5 déc';
                    break;
                  default:
                    text = '';
                }
                return Text(text, style: const TextStyle(fontSize: 12));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(value.toString(), style: const TextStyle(fontSize: 12));
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 2.0),
              FlSpot(1, 1.5),
              FlSpot(2, 1.8),
              FlSpot(3, 1.2),
              FlSpot(4, 1.9),
            ],
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: true),
          )
        ],
      ),
    );
  }
}

/// Graphique en barres utilisant fl_chart
class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 8,
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: 5, color: Colors.blue, width: 16),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: 6, color: Colors.blue, width: 16),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: 4, color: Colors.blue, width: 16),
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: 7, color: Colors.blue, width: 16),
          ]),
          BarChartGroupData(x: 4, barRods: [
            BarChartRodData(toY: 5.5, color: Colors.blue, width: 16),
          ]),
        ],
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = 'J1';
                    break;
                  case 1:
                    text = 'J2';
                    break;
                  case 2:
                    text = 'J3';
                    break;
                  case 3:
                    text = 'J4';
                    break;
                  case 4:
                    text = 'J5';
                    break;
                  default:
                    text = '';
                }
                return Text(text, style: const TextStyle(fontSize: 12));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(value.toString(), style: const TextStyle(fontSize: 12));
              },
            ),
          ),
        ),
      ),
    );
  }
}
