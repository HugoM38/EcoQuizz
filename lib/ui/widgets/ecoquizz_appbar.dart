import 'package:flutter/material.dart';
import 'package:ecoquizz/utils/shared_prefs_manager.dart';

class EcoQuizzAppBar extends StatefulWidget implements PreferredSizeWidget {
  const EcoQuizzAppBar({super.key, required this.title, this.tabBar});

  final String title;
  final TabBar? tabBar;

  @override
  State<EcoQuizzAppBar> createState() => _EcoQuizzAppBarState();

  @override
  Size get preferredSize {
    // Si un tabBar est fourni, on ajoute sa hauteur à celle de la barre d'outils
    if (tabBar != null) {
      return Size.fromHeight(kToolbarHeight + tabBar!.preferredSize.height);
    }
    return const Size.fromHeight(kToolbarHeight);
  }
}

class _EcoQuizzAppBarState extends State<EcoQuizzAppBar> {
  late bool _isLogged;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    _isLogged = await SharedPreferencesManager.isUserLoggedIn();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        widget.title,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      bottom: widget.tabBar,
      actions: [
        _isLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : _isLogged
                ? IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () async {
                      if (context.mounted) {
                        Navigator.pushNamed(context, '/user-page');
                      }
                    },
                  )
                : const SizedBox(),
        _isLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : _isLogged
                ? IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await SharedPreferencesManager.logoutUser();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      }
                    },
                  )
                : const SizedBox(),
      ],
    );
  }
}
