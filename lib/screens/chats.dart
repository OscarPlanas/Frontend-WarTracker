import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:war_tracker/components/Chat/chat_card.dart';
import 'package:war_tracker/constants.dart';
import 'package:war_tracker/controllers/chat_controller.dart';
import 'package:war_tracker/data/data.dart';
import 'package:war_tracker/models/Chat.dart';
import 'package:war_tracker/screens/messages.dart';
import 'package:war_tracker/sidebar.dart';
import 'package:get/get.dart';
import 'package:war_tracker/theme_provider.dart';
import 'package:war_tracker/screens/usersToChat.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  ChatController chatController = Get.put(ChatController());
  List<ChatModel> chats = [];
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    getChats();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    // Retrieve the saved theme mode from SharedPreferences
    ThemeMode savedThemeMode = await ThemeHelper.getThemeMode();
    print(savedThemeMode);
    setState(() {
      _themeMode = savedThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
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
                  },
                  themeMode: _themeMode),
            ),
          ),
          //open a new screen with all the users registered
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => UsersToChatScreen());
        },
        child: Icon(Icons.message, color: ButtonBlack),
        backgroundColor: Background,
      ),
    );
  }

  getChats() async {
    print("getChats en screen");
    final fetchedChats = await chatController.getChats(currentUser.id);
    // Sort the chats based on the timestamp of the latest message

    setState(() {
      chats = fetchedChats;
    });
    print(json.encode(chats));
  }
}
