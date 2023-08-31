import 'package:flutter/material.dart';
import 'package:war_tracker/models/message.dart';

class OwnMessageCard extends StatelessWidget {
  final MessageModel messageModel;
  final ThemeMode themeMode;

  const OwnMessageCard(
      {Key? key, required this.messageModel, required this.themeMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    messageModel.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      messageModel.time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.done_all,
                        size: 20,
                        color: themeMode == ThemeMode.dark
                            ? Colors.black
                            : Colors.grey),
                    SizedBox(width: 5),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
