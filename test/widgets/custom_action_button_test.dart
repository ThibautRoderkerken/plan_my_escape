import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_escape/widgets/custom_action_button.dart';

void main() {
  testWidgets('CustomActionButton displays label and triggers function on press', (WidgetTester tester) async {
    bool buttonPressed = false;

    // Création du widget à tester
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomActionButton(
          label: 'Test Button',
          onPressed: () => buttonPressed = true,
        ),
      ),
    ));

    // Vérification de l'affichage du texte du bouton
    expect(find.text('Test Button'), findsOneWidget);

    // Simulation d'un appui sur le bouton
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Vérification que la fonction onPressed a été déclenchée
    expect(buttonPressed, isTrue);
  });
}
