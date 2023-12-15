import 'package:flutter/material.dart';

// IMPORTANT: ce fichier n'est pas utilisé dans le projet final

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('Rechercher des vacances'),
            onTap: () {
              // Naviguer ou exécuter une action spécifique
            },
          ),
          ListTile(
            title: const Text('Contacter un administrateur'),
            onTap: () {
              // Naviguer ou exécuter une action spécifique
            },
          ),
        ],
      ),
    );
  }
}
