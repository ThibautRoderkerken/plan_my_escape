class ChatMessage {
  final String id;
  final int userId;
  final String text;
  final DateTime? timestamp;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.text,
    this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      userId: json['userId'] as int,
      text: json['text'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
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
