import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/http_connection_options.dart';
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
  bool _isInitialized = false;

  ChatViewModel(
      {required this.vacationIndex, required this.dashboardViewModel}) {
    _initializeSignalR().then((_) {
      fetchChatRooms();
    });
  }

  Future<void> _initializeSignalR() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('cookie')?.split('=')[1];

    HttpConnectionOptions options = HttpConnectionOptions(
      accessTokenFactory: () async => jwtToken ?? '',
    );

    _hubConnection = HubConnectionBuilder()
        .withUrl("https://porthos-intra.cg.helmo.be/E180314/hub/chat/")
        .withAutomaticReconnect()
        .build();

    try {
      await _hubConnection.start();
      _isInitialized = true;
      print("SignalR connecté");
    } catch (e) {
      print('Erreur de connexion SignalR: $e');
    }
  }

  void _handleReceivedMessage(List<Object?>? message) {
    // Vérifier si le message n'est pas null
    if (message == null) {
      print('Message reçu est null');
      return;
    }

    // Traiter et ajouter le message reçu à currentChatRoom.messages
    // Par exemple, convertir message en ChatMessage et l'ajouter à la liste
    // N'oubliez pas d'appeler notifyListeners() pour mettre à jour l'UI

    // Pour le moment, on affiche le message dans la console
    print('Message reçu : $message');
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
    // Afficher dans la console qu'on est dans fetchChatRooms
    print('fetchChatRooms');
    print("vacationIndex : $vacationIndex");
    try {
      var rooms = await _chatService.getChatRooms();
      // Afficher dans la console le nombre de salles de chat récupérées
      print('Nombre de salles de chat récupérées : ${rooms.length}');

      // Afficher le détails de chaque salle de chat
      for (var room in rooms) {
        print('Salle de chat : ${room.id} - ${room.name}');
        // On récupère l'id qui est dans le nom de la salle de chat. "Holiday:1" -> 1
        var id = int.parse(room.name.split(':')[1]);
        print("id : $id");

        // Si l'id de la salle de chat correspond à l'index de la vacation
        if (id == vacationIndex) {
          // On récupère les détails de la salle de chat
          await fetchChatRoomDetails(room.id);
          // On sort de la boucle
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
      // Afficher dans la console le nombre de messages récupérés
      print(
          'Nombre de messages récupérés : ${currentChatRoom!.messages.length}');
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
      id: 'temp-id',
      // Générez un identifiant temporaire ou obtenez-le d'une manière appropriée
      userId: 1,
      // Mettez ici l'ID de l'utilisateur actuel
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
