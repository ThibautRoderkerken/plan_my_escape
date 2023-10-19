import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_escape/screens/login_screen.dart';
import 'package:plan_my_escape/screens/dashboard/dashboard_screen.dart';
import 'package:plan_my_escape/widgets/custom_action_button.dart';

void main() {
  testWidgets('Tester que la page de connexion possède bien un titre "Connexion" en gras', (WidgetTester tester) async {
    // On créé la page de connexion
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: LoginScreen(),
      ),
    ));

    // On cherche le texte "Connexion" avec le style en gras
    expect(find.byWidgetPredicate(
          (Widget widget) =>
      widget is Text &&
          widget.data == 'Connexion' &&
          widget.style?.fontWeight == FontWeight.bold,
      description: 'Trouver un texte "Connexion" avec le style en gras',
    ), findsOneWidget);
  });

  testWidgets('Tester que le bouton de connexion redirige vers le tableau de bord', (WidgetTester tester) async {
    // On créé la page de connexion
    await tester.pumpWidget(const MaterialApp(
      home: LoginScreen(),
    ));

    // Trouve le bouton "Connexion" et simule un tapotement
    var loginButton = find.widgetWithText(CustomActionButton, 'Connexion');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);

    // Redessine le widget après l'interaction
    await tester.pumpAndSettle();

    // Vérifie que la nouvelle page est le DashboardMainScreen (ou toute autre vérification que vous souhaitez faire)
    expect(find.byType(DashboardMainScreen), findsOneWidget);
  });
}
