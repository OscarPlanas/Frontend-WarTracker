import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:war_tracker/components/Chat/user_card.dart';
import 'package:war_tracker/constants.dart';
import 'package:war_tracker/controllers/chat_controller.dart';
import 'package:war_tracker/controllers/user_controller.dart';
import 'package:war_tracker/data/data.dart';
import 'package:war_tracker/models/user.dart';
import 'package:war_tracker/screens/messages.dart';
import 'package:war_tracker/theme_provider.dart';

class UsersToChatScreen extends StatefulWidget {
  const UsersToChatScreen({Key? key}) : super(key: key);

  @override
  _UsersToChatScreenState createState() => _UsersToChatScreenState();
}

class _UsersToChatScreenState extends State<UsersToChatScreen> {
  UserController userController = Get.put(UserController());
  List<User> users = [];
  ThemeMode _themeMode = ThemeMode.system;
  ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    getUsers();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    // Retrieve the saved theme mode from SharedPreferences
    ThemeMode savedThemeMode = await ThemeHelper.getThemeMode();
    setState(() {
      _themeMode = savedThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(color: ButtonBlack),
        title: Text(
          (AppLocalizations.of(context)!.messageTo),
          style: TextStyle(color: ButtonBlack),
        ),
        backgroundColor: Background,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                // Check if the user is the current user
                if (user.id == currentUser.id) {
                  // Return an empty container if it's the current user
                  return Container();
                } else {
                  // Return the UserCard for other users
                  return UserCard(
                    user: user,
                    onTap: () {
                      chatController.createChat(currentUser.id, user.id);
                      Get.to(() => MessagesScreen(user));
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => MessagesScreen(currentUser));
        },
        child: Icon(Icons.message, color: ButtonBlack),
        backgroundColor: Background,
      ),
    );
  }

  getUsers() async {
    print("getUsers en screen");
    final fetchedUsers = await userController.getUsers();

    setState(() {
      users = fetchedUsers;
    });
  }
}
