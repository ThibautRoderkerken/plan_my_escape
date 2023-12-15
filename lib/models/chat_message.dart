class ChatMessage {
  final int id;
  final int userId;
  final String text;
  final DateTime? timestamp;
  final String firstName;
  final String lastName;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.text,
    required this.firstName,
    required this.lastName,
    this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    print("ChatMessage.fromJson");
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

    print("ChatMessage.fromJson 2");
    return chatMessage;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
