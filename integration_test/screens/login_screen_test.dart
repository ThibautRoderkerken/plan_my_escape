import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plan_my_escape/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Page de connexion", () {

    testWidgets("Vérifier que l'application démarre sur la page de connexion", (WidgetTester tester) async {
      // Lance l'application
      app.main();

      // Attendez que l'application se construise et effectuez le rendu.
      await tester.pumpAndSettle();

      // Vérifiez que l'élément avec la clé 'Connexion' est trouvé.
      expect(find.byKey(const Key('login_screen_title')), findsOneWidget);
    });

    testWidgets("Vérifier que nous arrivons sur le tableau de bord lorsque nous rentrons des identifiant valide", (WidgetTester tester) async {
      // Lance l'application
      app.main();

      // Attendez que l'application se construise et effectuez le rendu.
      await tester.pumpAndSettle();

      // Récupère les éléments de connexion
      final emailField = find.byKey(const Key('login_screen_email_field'));
      final passwordField = find.byKey(const Key('login_screen_password_field'));
      final loginButton = find.byKey(const Key('login_screen_login_button'));

      // Remplir les champs de connexion
      await tester.enterText(emailField, 'demo@gmail.com');
      await tester.enterText(passwordField, 'demo');

      // Appuyer sur le bouton de connexion
      await tester.tap(loginButton);

      // Attendez que l'application se construise et effectuez le rendu.
      await tester.pumpAndSettle();

      // Vérifiez que l'élément avec la clé 'dashboard_screen_title' est trouvé.
      expect(find.byKey(const Key('dashboard_screen_title')), findsOneWidget);
    });

    testWidgets("Vérifier que l'application nous renvoie un message d'erreur si nous entrons une adresse email invalide", (WidgetTester tester) async {
      // Lance l'application
      app.main();

      // Attendez que l'application se construise et effectuez le rendu.
      await tester.pumpAndSettle();

      // Récupère les éléments de connexion
      final emailField = find.byKey(const Key('login_screen_email_field'));
      final passwordField = find.byKey(const Key('login_screen_password_field'));
      final loginButton = find.byKey(const Key('login_screen_login_button'));

      // Remplir les champs de connexion
      await tester.enterText(emailField, 'lkjqhsdf');
      await tester.enterText(passwordField, 'demo');

      // Appuyer sur le bouton de connexion
      await tester.tap(loginButton);

      // Attendez que l'application se construise et effectuez le rendu.
      await tester.pumpAndSettle();

      // Vérifier que nous somme toujours sur la page de connexion
      expect(find.byKey(const Key('login_screen_title')), findsOneWidget);

      // Vérifier que le message d'erreur est affiché
      expect(find.text('Veuillez entrer un email valide'), findsOneWidget);
    });

    testWidgets("Vérifier que l'application nous renvoie un message d'erreur si le champ email est vide", (WidgetTester tester) async {
      // Lance l'application
      app.main();

      // Attendez que l'application se construise et effectuez le rendu.
      await tester.pumpAndSettle();

      // Récupère les éléments de connexion
      final emailField = find.byKey(const Key('login_screen_email_field'));
      final passwordField = find.byKey(const Key('login_screen_password_field'));
      final loginButton = find.byKey(const Key('login_screen_login_button'));

      // Remplir les champs de connexion
      await tester.enterText(emailField, '');
      await tester.enterText(passwordField, 'demo');

      // Appuyer sur le bouton de connexion
      await tester.tap(loginButton);

      // Attendez que l'application se construise et effectuez le rendu.
      await tester.pumpAndSettle();

      // Vérifier que nous somme toujours sur la page de connexion
      expect(find.byKey(const Key('login_screen_title')), findsOneWidget);

      // Vérifier que le message d'erreur est affiché
      expect(find.text('Ce champ ne peut pas être vide'), findsOneWidget);
    });

    testWidgets("Vérifier que l'application nous renvoie un message d'erreur si le champ password est vide", (WidgetTester tester) async {
      // Lance l'application
      app.main();

      // Attendez que l'application se construise et effectuez le rendu.
      await tester.pumpAndSettle();

      // Récupère les éléments de connexion
      final emailField = find.byKey(const Key('login_screen_email_field'));
      final passwordField = find.byKey(const Key('login_screen_password_field'));
      final loginButton = find.byKey(const Key('login_screen_login_button'));

      // Remplir les champs de connexion
      await tester.enterText(emailField, 'demo@gmail.com');
      await tester.enterText(passwordField, '');

      // Appuyer sur le bouton de connexion
      await tester.tap(loginButton);

      // Attendez que l'application se construise et effectuez le rendu.
      await tester.pumpAndSettle();

      // Vérifier que nous somme toujours sur la page de connexion
      expect(find.byKey(const Key('login_screen_title')), findsOneWidget);

      // Vérifier que le message d'erreur est affiché
      expect(find.text('Ce champ ne peut pas être vide'), findsOneWidget);
    });

  });
}
