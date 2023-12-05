import 'package:flutter/material.dart';
import '../models/chat_room.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatViewModel with ChangeNotifier {
  final ChatService _chatService = ChatService();
  ChatRoom? currentChatRoom;

  // Messages actuels de la salle de chat
  List<ChatMessage> get messages => currentChatRoom?.messages ?? [];

  // Récupérer les salles de chat de l'utilisateur
  Future<void> fetchChatRooms() async {
    try {
      var rooms = await _chatService.getChatRooms();
      // Vous pouvez ajouter une logique supplémentaire ici si nécessaire
      notifyListeners();
    } catch (e) {
      // Gérer l'exception ici
    }
  }

  // Récupérer les détails d'une salle de chat spécifique
  Future<void> fetchChatRoomDetails(int roomId) async {
    try {
      currentChatRoom = await _chatService.getChatRoomDetails(roomId);
      notifyListeners();
    } catch (e) {
      // Gérer l'exception ici
    }
  }

  // Envoyer un message
  Future<void> sendMessage(String text) async {
    if (currentChatRoom == null) return;

    // Créer un objet ChatMessage
    var newMessage = ChatMessage(
      id: 'temp-id', // Générez un identifiant temporaire ou obtenez-le d'une manière appropriée
      userId: 1, // Mettez ici l'ID de l'utilisateur actuel
      text: text,
      timestamp: DateTime.now(),
    );

    try {
      await _chatService.sendChatMessage(newMessage);
      currentChatRoom!.messages.add(newMessage);
      notifyListeners();
    } catch (e) {
      // Gérer l'exception ici
    }
  }
}
