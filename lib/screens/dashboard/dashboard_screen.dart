import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_vacation_screen.dart';
import 'display_vacations_screen.dart';
import '../navigation_drawer_screen.dart';
import '../../view_models/dashboard/add_vacation_view_model.dart';
import '../../view_models/dashboard/display_vacations_view_model.dart';
import '../../view_models/dashboard/dashboard_view_model.dart'; // Assurez-vous d'importer DashboardViewModel

class DashboardMainScreen extends StatelessWidget {
  DashboardMainScreen({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        key: const Key('dashboard_screen_title'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChangeNotifierProvider(
                create: (_) => AddVacationViewModel(dashboardViewModel: dashboardViewModel),
                child: AddVacationScreen(
                  onVacationAdded: () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Provider<DisplayVacationsViewModel>(
                create: (_) => DisplayVacationsViewModel(dashboardViewModel: dashboardViewModel),
                child: DisplayVacationsScreen(),
              ),
            ],
          ),
        ),
      ),
      drawer: const AppNavigationDrawer(),
    );
  }
}
