import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_escape/models/chat_message.dart';

void main() {
  group('ChatMessage Model Tests', () {
    // Test de Constructeur
    test('ChatMessage Constructor Test', () {
      final chatMessage = ChatMessage(
        id: 1,
        userId: 2,
        text: 'Bonjour',
        firstName: 'Alice',
        lastName: 'Dupont',
      );

      expect(chatMessage.id, 1);
      expect(chatMessage.userId, 2);
      expect(chatMessage.text, 'Bonjour');
      expect(chatMessage.firstName, 'Alice');
      expect(chatMessage.lastName, 'Dupont');
      expect(chatMessage.timestamp, isNull);
    });

    // Test de fromJson
    test('ChatMessage FromJson Test', () {
      final json = {
        'id': 3,
        'owner': {
          'id': 4,
          'firstname': 'Bob',
          'lastname': 'Martin',
        },
        'text': 'Salut',
        'timestamp': '2023-01-01T10:00:00',
      };

      final chatMessage = ChatMessage.fromJson(json);

      expect(chatMessage.id, 3);
      expect(chatMessage.userId, 4);
      expect(chatMessage.firstName, 'Bob');
      expect(chatMessage.lastName, 'Martin');
      expect(chatMessage.text, 'Salut');
      expect(chatMessage.timestamp, DateTime(2023, 1, 1, 10));
    });

    // Test de toJson
    test('ChatMessage ToJson Test', () {
      final chatMessage = ChatMessage(
        id: 5,
        userId: 6,
        text: 'Hello',
        firstName: 'Carol',
        lastName: 'Taylor',
      );

      final json = chatMessage.toJson();

      expect(json['text'], 'Hello');
      expect(json['owner']['id'], 6);
      expect(json['chatroom']['id'], 0);
    });

    // Test de fromMap
    test('ChatMessage FromMap Test', () {
      final map = [
        7,
        8,
        'Hey',
        'Dave',
        'Smith',
        DateTime(2023, 1, 1, 12)
      ];

      final chatMessage = ChatMessage.fromMap(map);

      expect(chatMessage.id, 7);
      expect(chatMessage.userId, 8);
      expect(chatMessage.firstName, 'Dave');
      expect(chatMessage.lastName, 'Smith');
      expect(chatMessage.text, 'Hey');
      expect(chatMessage.timestamp, DateTime(2023, 1, 1, 12));
    });
  });
}
