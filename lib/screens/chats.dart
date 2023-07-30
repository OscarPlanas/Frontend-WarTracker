import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/Chat/chat_card.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/chat_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/Chat.dart';
import 'package:frontend/screens/messages.dart';
//import 'package:frontend/models/ChatPlaceholder.dart';
import 'package:frontend/sidebar.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  ChatController chatController = Get.put(ChatController());
  List<ChatModel> chats = [];
  @override
  void initState() {
    super.initState();
    getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title: const Text(('Chats'), style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) => ChatCard(
                  chat: chats[index],
                  press: () {
                    if (chats[index].client1.id == currentUser.id)
                      Get.to(() => MessagesScreen(chats[index].client2));
                    else
                      Get.to(() => MessagesScreen(chats[index].client1));
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
    );
  }

  getChats() async {
    print("getChats en screen");
    final fetchedChats = await chatController.getChats(currentUser.id);
    setState(() {
      chats = fetchedChats;
    });
    print(json.encode(chats));
  }
}
