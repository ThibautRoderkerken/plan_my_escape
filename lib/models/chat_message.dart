class ChatMessage {
  final int id;
  final int userId;
  final String text;
  final DateTime? timestamp;
  String firstName;
  String lastName;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.text,
    required this.firstName,
    required this.lastName,
    this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    ChatMessage chatMessage = ChatMessage(
      id: json['id'],
      // userId est en entier dans owner['id']
      userId: json['owner']['id'],
      firstName: json['owner']['firstname'],
      lastName: json['owner']['lastname'],
      text: json['text'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );

    return chatMessage;
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'chatroom': {
        'id': 0,
      },
      'owner': {
        'id': userId,
      },
    };
  }

  static ChatMessage? fromMap(List<Object?>? message) {
    if (message == null || message.isEmpty) {
      return null;
    }

    var firstElement = message[0];

    // S'assurer que le premier élément est bien un Map
    if (firstElement is! Map) {
      return null;
    }

    try {
      return ChatMessage(
        id: firstElement['id'] as int,
        userId: firstElement['owner']['id'] as int,
        firstName: firstElement['owner']['firstname'] as String,
        lastName: firstElement['owner']['lastname'] as String,
        text: firstElement['text'] as String,
        timestamp: firstElement['timestamp'] != null
            ? DateTime.parse(firstElement['timestamp'])
            : null,
      );
    } catch (e) {
      return null;
    }
  }
}

