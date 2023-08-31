import 'package:war_tracker/models/user.dart';

class ChatModel {
  String id;
  User client1;
  User client2;
  List<dynamic> messages;

  ChatModel({
    required this.id,
    required this.client1,
    required this.client2,
    required this.messages,
  });

  Map<String, dynamic> toJson() {
    return {
      'messages': messages,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      client1: User.fromJson(json['client1']),
      client2: User.fromJson(json['client2']),
      messages: List<String>.from(json['messages']),
    );
  }
}
