import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
      ),
      body: const Center(
        child: Text('Bienvenue sur le tableau de bord !'),
      ),
      drawer: Drawer(
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

              },
            ),
            ListTile(
              title: const Text('Contacter un administrateur'),
              onTap: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}
