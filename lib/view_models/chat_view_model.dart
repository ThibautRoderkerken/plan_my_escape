import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import '../models/chat_room.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';
import 'dashboard/dashboard_view_model.dart';

class ChatViewModel with ChangeNotifier {
  final ChatService _chatService = ChatService();
  ChatRoom? currentChatRoom;
  final int vacationIndex;
  final DashboardViewModel dashboardViewModel;
  late HubConnection _hubConnection;

  ChatViewModel(
      {required this.vacationIndex, required this.dashboardViewModel}) {
    _initializeSignalR().then((_) {
      fetchChatRooms();
    });
  }

  Future<void> _initializeSignalR() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('cookie');
    String url =
        "https://porthos-intra.cg.helmo.be/E180314/hub/chat/?$jwtToken";

    _hubConnection =
        HubConnectionBuilder().withUrl(url).withAutomaticReconnect().build();

    try {
      _hubConnection.on('SendMessage', (message) {
        // Traiter le message reçu
        var chatMessage = ChatMessage.fromMap(message);

        currentChatRoom!.messages.add(chatMessage!);
        notifyListeners();
      });
      await _hubConnection.start();
    } catch (e) {
      // S'il y a une erreur, la vue ne sera pas mise à jour
    }
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

  // Messages actuels de la salle de chat
  List<ChatMessage> get messages => currentChatRoom?.messages ?? [];

  // Récupérer les salles de chat de l'utilisateur
  Future<void> fetchChatRooms() async {
    try {
      var rooms = await _chatService.getChatRooms();
      for (var room in rooms) {
        var id = int.parse(room.name.split(':')[1]);
        if (id == vacationIndex) {
          await fetchChatRoomDetails(room.id);
          break;
        }
      }
      notifyListeners();
    } catch (e) {
      // Gérer l'exception ici
    }
  }

  // Récupérer les détails d'une salle de chat spécifique
  Future<void> fetchChatRoomDetails(int roomId) async {
    try {
      currentChatRoom = await _chatService.getChatRoomDetails(roomId);
      await joinChatRoom(currentChatRoom!.id);
      notifyListeners();
    } catch (e) {
      // S'il y a une erreur, la vue ne sera pas mise à jour
    }
  }

  sendMessage(ChatMessage newMessage) async {
    // On ajoute le message dans currentChatRoom
    currentChatRoom?.messages.add(newMessage);

    // On envoie le message au service
    await _chatService.sendChatMessage(currentChatRoom!);

    currentChatRoom?.messages.remove(newMessage);
    // On notifie les listeners
    notifyListeners();
  }

  // Rejoindre un chatRoom
  Future<void> joinChatRoom(int chatId) async {
    try {
      await _hubConnection.invoke('Join', args: <Object>[chatId.toString()]);
    } catch (e) {
      // S'il y a une erreur, la vue ne sera pas mise à jour
    }
  }

  // Quitter un chatRoom
  Future<void> leaveChatRoom(int chatId) async {
    try {
      await _hubConnection.invoke('Leave', args: <Object>[chatId.toString()]);
    } catch (e) {
      // S'il y a une erreur, la vue ne sera pas mise à jour
    }
  }
}
