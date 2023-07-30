import 'package:frontend/models/Chat.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/Chat.dart';
import 'package:frontend/data/data.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final ChatModel chat;
  final VoidCallback press;

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
                /*if (chat.isActive)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF66BB6A),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3),
                      ),
                    ),
                  )*/
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
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),

                    if (chat.client2.id == currentUser.id)
                      Text(
                        chat.client1.username,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    const SizedBox(height: 8),
                    // Opacity(
                    //   opacity: 0.64,
                    //   child: Text(
                    //     chat.lastMessage,
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            // Opacity(
            //   opacity: 0.64,
            //   child: Text(chat.time),
            // ),
          ],
        ),
      ),
    );
  }
}
