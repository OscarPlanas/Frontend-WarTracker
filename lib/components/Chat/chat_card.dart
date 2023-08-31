import 'package:war_tracker/models/Chat.dart';
import 'package:flutter/material.dart';
import 'package:war_tracker/data/data.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
    required this.themeMode,
  }) : super(key: key);

  final ChatModel chat;
  final VoidCallback press;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10 * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                if (currentUser.id == chat.client1.id)
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(chat.client2.imageUrl),
                  ),
                if (currentUser.id == chat.client2.id)
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(chat.client1.imageUrl),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chat.client1.id == currentUser.id)
                      Text(
                        chat.client2.username,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    if (chat.client2.id == currentUser.id)
                      Text(
                        chat.client1.username,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
