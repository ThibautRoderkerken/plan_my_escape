import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_escape/models/member.dart';

void main() {
  group('Member Model Tests', () {
    // Test de Constructeur
    test('Member Constructor Test', () {
      final member = Member(
        id: '123',
        firstName: 'Alice',
        lastName: 'Dupont',
        mail: 'alice@example.com',
      );

      expect(member.id, '123');
      expect(member.firstName, 'Alice');
      expect(member.lastName, 'Dupont');
      expect(member.mail, 'alice@example.com');
    });

    // Test de fromJson
    test('Member FromJson Complete Data Test', () {
      final json = {
        'id': '456',
        'firstname': 'Bob',
        'lastname': 'Martin',
        'email': 'bob@example.com',
      };

      final member = Member.fromJson(json);

      expect(member.id, '456');
      expect(member.firstName, 'Bob');
      expect(member.lastName, 'Martin');
      expect(member.mail, 'bob@example.com');
    });

    test('Member FromJson Incomplete Data Test', () {
      final json = {
        'id': '789',
        // firstname is missing
        'lastname': 'Taylor',
        'email': 'taylor@example.com',
      };

      final member = Member.fromJson(json);

      expect(member.id, '789');
      // firstName should fallback to email as per the fromJson logic
      expect(member.firstName, 'taylor@example.com');
      expect(member.lastName, 'Taylor');
      expect(member.mail, 'taylor@example.com');
    });
  });
}
