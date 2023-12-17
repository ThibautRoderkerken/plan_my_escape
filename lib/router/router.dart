import 'package:flutter/material.dart';
import 'package:plan_my_escape/screens/add_activity_screen.dart';
import 'package:plan_my_escape/screens/add_member_screen.dart';
import 'package:plan_my_escape/screens/chat_screen.dart';
import 'package:plan_my_escape/screens/dashboard/dashboard_screen.dart';
import 'package:plan_my_escape/screens/login_screen.dart';
import 'package:plan_my_escape/screens/sign_up_screen.dart';
import 'package:plan_my_escape/screens/update_vacation_screen.dart';
import 'package:plan_my_escape/utils/custom_page.dart';
import 'package:plan_my_escape/view_models/chat_view_model.dart';
import 'package:plan_my_escape/view_models/dashboard/dashboard_view_model.dart';
import 'package:plan_my_escape/view_models/login_view_model.dart';
import 'package:plan_my_escape/view_models/sign_up_view_model.dart';
import 'package:plan_my_escape/view_models/update_vacation_view_model.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    CustomPage customPage;
    double borderSize = 16.0;

    switch (settings.name) {
      case '/':
        customPage = CustomPage(
          page: ChangeNotifierProvider(
            create: (context) => LoginViewModel(),
            child: const LoginScreen(),
          ),
          title: 'Plan My Escape',
        );
        break;
      case '/sign_up':
        customPage = CustomPage(
          page: ChangeNotifierProvider(
            create: (context) => SignUpViewModel(),
            child: const SignUpScreen(),
          ),
          title: 'Créer un compte',
        );
        break;
      case '/dashboard':
        customPage = CustomPage(
          page: ChangeNotifierProvider(
            create: (context) => DashboardViewModel(),
            child: DashboardMainScreen(),
          ),
          title: 'Tableau de bord',
        );
        break;
      case '/dashboard/add_activity':
        final args = settings.arguments as Map<String, dynamic>;
        customPage = CustomPage(
          page: ChangeNotifierProvider.value(
            value: args['dashboardViewModel'] as DashboardViewModel,
            child: AddActivityScreen(
              vacationIndex: args['vacationIndex'] as int,
            ),
          ),
          title: 'Ajouter une activité',
        );
        break;
      case '/dashboard/add_member':
        final args = settings.arguments as Map<String, dynamic>;
        customPage = CustomPage(
          page: ChangeNotifierProvider.value(
            value: args['dashboardViewModel'] as DashboardViewModel,
            child: AddParticipantScreen(
              vacationIndex: args['vacationIndex'] as int,
            ),
          ),
          title: 'Ajouter un membre',
        );
        break;
      case '/dashboard/chat':
        final args = settings.arguments as Map<String, dynamic>;
        borderSize = 0.0;
        customPage = CustomPage(
          page: ChangeNotifierProvider.value(
            value: ChatViewModel(
              dashboardViewModel: args['dashboardViewModel'] as DashboardViewModel,
              vacationIndex: args['vacationIndex'] as int,
            ),
            child: const ChatScreen(),
          ),
          title: 'Chat',
        );
        break;
      case '/dashboard/updateVacation':
        final args = settings.arguments as Map<String, dynamic>;
        customPage = CustomPage(
          page: ChangeNotifierProvider.value(
            value: UpdateVacationViewModel(
              dashboardViewModel: args['dashboardViewModel'] as DashboardViewModel,
            ),
            child: UpdateVacationScreen(
              vacationIndex: args['vacationIndex'] as int,
              destination: args['destination'] as String,
              startDate: args['startDate'] as DateTime,
              endDate: args['endDate'] as DateTime,
            ),
          ),
          title: 'Modifier une période de vacances',
        );
        break;
      default:
        return _errorRoute();
    }

    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text(customPage.title)),
        body: Padding(
          padding: EdgeInsets.all(borderSize),
          child: customPage.page,
        ),
      ),
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('Page not found'),
          ),
        );
      },
    );
  }
}
