import 'dart:convert';

import 'package:frontend/data/data.dart';
import 'package:frontend/models/Chat.dart';
import 'package:frontend/models/message.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  void createChat(idUserOpening, idUserReceiver) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      var url = Uri.parse('http://10.0.2.2:5432/api/chats/createchat');
      Map body = {
        'idUserOpening': idUserOpening,
        'idUserReceiver': idUserReceiver,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        print("correcto");
      } else {
        print("incorrecto");
      }
    } catch (error) {}
  }

  Future<List<ChatModel>> getChats(idUser) async {
    List<ChatModel> chats = [];
    final data = await http.get(Uri.parse(
        'http://10.0.2.2:5432/api/chats/getAllChatsOfUser/' + currentUser.id));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      ChatModel chat = ChatModel.fromJson({
        "_id": u["_id"],
        "client1": u["client1"],
        "client2": u["client2"],
        "messages": u["messages"],
      });

      chats.add(chat);
    }
    return chats;
  }

  Future<ChatModel?> getChat(idUserOpening, idUserRecieving) async {
    try {
      final data = await http.get(Uri.parse(
          'http://10.0.2.2:5432/api/chats/getChatByUsers/' +
              idUserOpening +
              '/' +
              idUserRecieving));
      var jsonData = json.decode(data.body);

      if (jsonData is List && jsonData.isNotEmpty) {
        // Extract the first chat object from the array
        var chatData = jsonData[0];
        ChatModel chat = ChatModel.fromJson({
          "_id": chatData["_id"],
          "client1": chatData["client1"],
          "client2": chatData["client2"],
          "messages": chatData["messages"],
        });

        return chat;
      } else {
        // If the JSON response is empty or not an array, return null
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  void saveMessage(idChat, idUser, message) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      var url = Uri.parse('http://10.0.2.2:5432/api/messages/saveMessage');
      Map body = {
        'chat': idChat,
        'user': idUser,
        'message': message,
        'date': DateTime.now().toString().substring(10, 16),
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        print("correcto");
      } else {
        print("incorrecto");
      }
    } catch (error) {
      print(error);
      //Get.back();
    }
  }

  Future<List<MessageModel>> getMessages(idChat) async {
    List<MessageModel> messages = [];
    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/messages/' + idChat));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      MessageModel message = MessageModel.fromJson({
        "chat": u["chat"],
        "user": u["user"],
        "message": u["message"],
        "date": u["date"],
      });
      print(message.message);

      messages.add(message);
    }
    return messages;
  }
}
