import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_escape/widgets/custom_text_field.dart';

void main() {
  testWidgets('CustomTextField validation test', (WidgetTester tester) async {
    final key = GlobalKey<FormState>();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Form(
          key: key,
          child: CustomTextField(
            label: 'Test Field',
            isObscure: false,
          ),
        ),
      ),
    ));

    // Test pour une valeur null (ou champ non rempli)
    key.currentState!.validate();
    await tester.pump();
    expect(find.text('Ce champ ne peut pas être vide'), findsOneWidget);

    // Test pour une chaîne vide
    await tester.enterText(find.byType(TextFormField), '');
    key.currentState!.validate();
    await tester.pump();
    expect(find.text('Ce champ ne peut pas être vide'), findsOneWidget);
  });

}
