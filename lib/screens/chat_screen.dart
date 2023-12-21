import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../view_models/chat_view_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  late final Future<types.User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _getUser();
  }

  Future<types.User> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userID') ?? '';
    return types.User(id: userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<types.User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final user = snapshot.data!;
            return Consumer<ChatViewModel>(
              builder: (context, viewModel, child) {
                _messages = viewModel.messages.map((chatMessage) {
                  var author = types.User(
                    id: chatMessage.userId.toString(),
                    firstName: chatMessage.firstName,
                    lastName: chatMessage.lastName,
                  );

                  return types.TextMessage(
                    author: author,
                    createdAt: chatMessage.timestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
                    id: const Uuid().v4(),
                    text: "${author.lastName} ${author.firstName}:\n${chatMessage.text}",
                  );
                }).toList().reversed.toList();


                return Chat(
                  messages: _messages,
                  onSendPressed: (message) =>
                      _handleSendPressed(message, viewModel, user.id),
                  user: user,
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  void _handleSendPressed(
      types.PartialText message, ChatViewModel viewModel, String userId) {
    final newMessage = ChatMessage(
      id: 0,
      userId: int.parse(userId),
      text: message.text,
      timestamp: DateTime.now(),
      firstName: "",
      lastName: "",
    );

    viewModel.sendMessage(newMessage);
  }
}
