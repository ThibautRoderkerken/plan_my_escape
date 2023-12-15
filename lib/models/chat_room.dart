import 'chat_message.dart';

class ChatRoom {
  final int id;
  final String name;
  final List<ChatMessage> messages;

  ChatRoom({required this.id, required this.name, required this.messages});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    // Afficher le contenu de json
    ChatRoom chatRoom =  ChatRoom(
      id: json['id'],
      name: json['name'] as String,
      messages: (json['messages'] as List)
          .map((message) => ChatMessage.fromJson(message))
          .toList(),
    );

    return chatRoom;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
