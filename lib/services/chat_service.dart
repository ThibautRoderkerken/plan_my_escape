import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_room.dart';
import '../exceptions/bad_request_exception.dart';
import '../exceptions/internal_server_exception.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/not_found_exception.dart';

class ChatService {
  final String baseUrl = "https://porthos-intra.cg.helmo.be/e180314/api/Chat";

  Future<List<ChatRoom>> getChatRooms() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        return List<ChatRoom>.from(l.map((model) => ChatRoom.fromJson(model)));
      } else {
        throw _handleError(response.statusCode, response.body);
      }
    } on TimeoutException {
      throw NetworkException('Network timeout');
    } catch (e) {
      if (e is! Exception) {
        throw NetworkException('Network error: $e');
      }
      rethrow;
    }
  }

  Future<ChatRoom> getChatRoomDetails(int roomId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      final response = await http.get(
        Uri.parse('$baseUrl/$roomId'),
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
      ).timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        return ChatRoom.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response.statusCode, response.body);
      }
    } on TimeoutException {
      throw NetworkException('Network timeout');
    } catch (e) {
      if (e is! Exception) {
        throw NetworkException('Network error: $e');
      }
      rethrow;
    }
  }

  Future<void> sendChatMessage(ChatRoom message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');
      String bodyRequest = jsonEncode(message.toJson());
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
        body: bodyRequest,
      ).timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw NetworkException('Network timeout');
    } catch (e) {
      if (e is! Exception) {
        throw NetworkException('Network error: $e');
      }
      rethrow;
    }
  }

  Exception _handleError(int statusCode, String responseBody) {
    switch (statusCode) {
      case 400:
        return BadRequestException('Bad request: $responseBody');
      case 404:
        return NotFoundException('Resource not found');
      case 500:
        return InternalServerException('Internal server error');
      default:
        return NetworkException('Unknown network error');
    }
  }
}
