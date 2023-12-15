import 'package:flutter/material.dart';
import 'package:plan_my_escape/screens/login_screen.dart';
import 'package:plan_my_escape/screens/sign_up_screen.dart';
import 'package:plan_my_escape/utils/custom_page.dart';
import 'package:plan_my_escape/view_models/login_view_model.dart';
import 'package:plan_my_escape/view_models/sign_up_view_model.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    CustomPage customPage;

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
      default:
        return _errorRoute();
    }

    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text(customPage.title)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
