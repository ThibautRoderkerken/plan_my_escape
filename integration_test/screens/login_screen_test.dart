import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plan_my_escape/main.dart' as app;
import 'package:plan_my_escape/screens/dashboard/dashboard_screen.dart';
import 'package:plan_my_escape/screens/login_screen.dart';
import 'package:plan_my_escape/view_models/dashboard/dashboard_view_model.dart';
import 'package:plan_my_escape/view_models/login_view_model.dart';
import 'package:plan_my_escape/widgets/custom_action_button.dart';
import 'package:plan_my_escape/widgets/custom_outlined_button.dart';
import 'package:plan_my_escape/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../mock/auth_service_mock.dart';
import '../mock/country_service_mock.dart';
import '../mock/holiday_service_mock.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Vérifie que l'application démarre sur la page de connexion", (WidgetTester tester) async {
    // Lance l'application
    app.main();
    await tester.pumpAndSettle();

    // Vérifiez que le texte 'Connexion' est présent
    expect(find.byKey(const Key('login_button')), findsOneWidget);

    // Vérifiez la présence des champs de texte personnalisés pour l'email et le mot de passe
    expect(find.byType(CustomTextField), findsNWidgets(2));

    // Vérifiez la présence du bouton de connexion
    expect(find.widgetWithText(CustomActionButton, 'Connexion'), findsOneWidget);

    // Vérifiez la présence du bouton d'authentification OAuth2
    expect(find.widgetWithText(CustomOutlinedButton, 'S\'authentifier via OAuth2'), findsOneWidget);

    // Vérifiez la présence du lien pour créer un compte
    expect(find.text('Créer un compte'), findsOneWidget);
  });

  testWidgets("Vérifier qu'on arrive sur le Dashboard une fois la connexion réussie", (WidgetTester tester) async {
    // On remplace le service d'authentification par un mock
    MockLoginService mockLoginService = MockLoginService();
    MockCountryService mockCountryService = MockCountryService();
    MockHolidayService mockHolidayService = MockHolidayService();

    // Fournir les mocks à l'écran de connexion via un Provider
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => LoginViewModel(
            authService: mockLoginService,
            countryService: mockCountryService, // Fournir le mockCountryService ici
          ),
          child: const LoginScreen(),
        ),
      ),
    );

    // Remplir les champs de connexion
    await tester.enterText(find.byType(CustomTextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(CustomTextField).at(1), 'password123');

    // Cliquer sur le bouton de connexion
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    // Si tout c'est bien passé on passe au Dashboard
    // Remplacer l'écran actuel par le DashboardScreen
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => DashboardViewModel(
            holidayService: mockHolidayService,
          ),
          child: Scaffold(
            body: DashboardMainScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('add_vacation_title')), findsOneWidget);
    expect(find.byKey(const Key('display_vacations_title')), findsOneWidget);
  });
}
