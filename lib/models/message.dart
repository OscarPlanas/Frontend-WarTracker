class MessageModel {
  String chat;
  String message;
  String user;
  String time;

  MessageModel(
      {required this.chat,
      required this.message,
      required this.time,
      required this.user});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      chat: json['chat'],
      message: json['message'],
      user: json['user'], // Deserialize the User object
      time: json['date'],
    );
  }
}
