import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../view_models/chat_view_model.dart';

class ChatScreen extends StatefulWidget {
  final Future<String> userID = SharedPreferences.getInstance().then((prefs) => prefs.getString('userID') ?? '');
  ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  late final types.User _user; // Déclare _user comme late

  @override
  void initState() {
    super.initState();
    // Une fois que userId est disponible, initialisez _user
    widget.userID.then((userId) {
      setState(() {
        _user = types.User(id: userId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          // Mise à jour des messages lorsque notifyListeners est appelé dans le ViewModel
          _messages = viewModel.messages.map((chatMessage) {
            return types.TextMessage(
              author: chatMessage.userId.toString() == _user.id
                  ? _user
                  : types.User(id: chatMessage.userId.toString()),
              createdAt: chatMessage.timestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
              id: const Uuid().v4(),
              text: chatMessage.text,
            );
          }).toList();

          return Chat(
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user,
          );
        },
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    // Logique pour envoyer un message
    // ...
    // Ajoutez le message à l'interface utilisateur
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
}
