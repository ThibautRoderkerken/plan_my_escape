import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_escape/widgets/custom_outlined_button.dart';

void main() {
  testWidgets('CustomOutlinedButton displays label and triggers function on press', (WidgetTester tester) async {
    bool buttonPressed = false;

    await tester.pumpWidget(MaterialApp(
      home: CustomOutlinedButton(
        label: 'Test Button',
        onPressed: () {
          buttonPressed = true;
        },
      ),
    ));

    // Vérifier l'affichage du texte du bouton
    expect(find.text('Test Button'), findsOneWidget);

    // Appuyer sur le bouton et vérifier si la fonction onPressed a été appelée
    await tester.tap(find.byType(OutlinedButton));
    expect(buttonPressed, isTrue);
  });
}
