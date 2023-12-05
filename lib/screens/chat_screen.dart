import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final types.User _user = types.User(id: const Uuid().v4());

  @override
  void initState() {
    super.initState();
    // Ajouter des messages de démonstration
    _addDemoMessages();
  }

  void _addDemoMessages() {
    final message1 = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: 'Bonjour ! Ceci est un message de démonstration.',
    );
    final message2 = types.TextMessage(
      author: types.User(id: const Uuid().v4()), // ID différent pour simuler un autre utilisateur
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: 'Salut ! Cela ressemble à une application de chat géniale.',
    );

    setState(() {
      _messages.insert(0, message1);
      _messages.insert(0, message2);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}
