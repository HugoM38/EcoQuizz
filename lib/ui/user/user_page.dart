import 'package:ecoquizz/ui/widgets/EcoQuizz_appbar.dart';
import 'package:flutter/material.dart';
import 'stats_tab.dart';
import 'history_tab.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EcoQuizzAppBar(
        title: "Statistiques et historique",
        tabBar: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          tabs: const [
            Tab(text: "Statistiques"),
            Tab(text: "Historique"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          StatsTab(),
          HistoryTab(),
        ],
      ),
    );
  }
}
