import 'package:flutter_test/flutter_test.dart';
import 'package:plan_my_escape/models/chat_message.dart';
import 'package:plan_my_escape/models/chat_room.dart';

void main() {
  group('ChatRoom Model Tests', () {
    // Création d'un message de test
    final testMessage = ChatMessage(
      id: 1,
      userId: 2,
      text: 'Bonjour',
      firstName: 'Alice',
      lastName: 'Dupont',
    );

    // Test de Constructeur
    test('ChatRoom Constructor Test', () {
      final chatRoom = ChatRoom(
        id: 3,
        name: 'Room A',
        messages: [testMessage],
      );

      expect(chatRoom.id, 3);
      expect(chatRoom.name, 'Room A');
      expect(chatRoom.messages.length, 1);
      expect(chatRoom.messages.first, testMessage);
    });

    // Test de fromJson
    test('ChatRoom FromJson Test', () {
      final json = {
        'id': 4,
        'name': 'Room B',
        'messages': [
          {
            'id': 5,
            'owner': {
              'id': 6,
              'firstname': 'Bob',
              'lastname': 'Martin',
            },
            'text': 'Salut',
            'timestamp': '2023-01-01T10:00:00',
          },
        ],
      };

      final chatRoom = ChatRoom.fromJson(json);

      expect(chatRoom.id, 4);
      expect(chatRoom.name, 'Room B');
      expect(chatRoom.messages.length, 1);
      expect(chatRoom.messages.first.id, 5);
      expect(chatRoom.messages.first.userId, 6);
      expect(chatRoom.messages.first.text, 'Salut');
    });

    // Test de toJson
    test('ChatRoom ToJson Test', () {
      final chatRoom = ChatRoom(
        id: 7,
        name: 'Room C',
        messages: [testMessage],
      );

      final json = chatRoom.toJson();

      expect(json['text'], 'Bonjour');
      expect(json['owner']['id'], 2);
      expect(json['chatroom']['id'], 7);
      expect(json['chatroom']['messages'], isEmpty);
    });
  });
}
