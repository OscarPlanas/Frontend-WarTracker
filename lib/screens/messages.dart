import 'dart:convert';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:war_tracker/components/Messages/OwnMessageCard.dart';
import 'package:war_tracker/components/Messages/ReplyCard.dart';
import 'package:war_tracker/constants.dart';
import 'package:war_tracker/controllers/chat_controller.dart';
import 'package:war_tracker/data/data.dart';
import 'package:war_tracker/models/Chat.dart';
import 'package:war_tracker/models/message.dart';
import 'package:war_tracker/models/user.dart';
import 'package:war_tracker/screens/profile.dart';
import 'package:war_tracker/theme_provider.dart';

class MessagesScreen extends StatefulWidget {
  final User user;

  MessagesScreen(this.user);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  IO.Socket? socket;
  bool sendButton = false;

  List<MessageModel> messages = [];
  final TextEditingController _messageController = TextEditingController();
  ChatController chatController = Get.put(ChatController());

  bool _isChatFetched = false; // Add this variable
  bool _isInitialScrollCompleted = false; // Add this variable

  ChatModel? chat;

  final ScrollController _scrollController = ScrollController();

  ThemeMode _themeMode = ThemeMode.system;
  var isEmojiVisible = false.obs;
  FocusNode focusNode = FocusNode();

  bool isUserOnline = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojiVisible.value = false;
      }
    });
    connect();
    if (!_isChatFetched) {
      fetchChat();
    }
    _loadThemeMode();
  }

  @override
  void dispose() {
    // Dispose the ScrollController when the widget is disposed
    _scrollController.dispose();
    socket!.emit('userOffline', currentUser.id);
    socket?.disconnect();
    socket?.dispose();
    super.dispose();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call _scrollToBottom only once after the ListView is built
    if (!_isInitialScrollCompleted && _isChatFetched) {
      _isInitialScrollCompleted = true;
      // Delay the call to _scrollToBottom until the ListView is fully rendered
      Future.delayed(Duration.zero, () {
        _scrollToBottom();
      });
    }
  }

  void connect() {
    //socket = IO.io("http://app.oscarplanas.com:5432", <String, dynamic>{
    socket = IO.io("http://10.0.2.2:5432", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.emit("signin", currentUser.id);
    socket!.onConnect((data) {
      print('Connected');
      socket!.on("message", (msg) {
        print(msg);
        setMessage("destination", msg["message"]);
      });
    });
    socket!.onConnectError((error) {
      print('Connection Error: $error');
    });
    socket!.onConnectTimeout((timeout) {
      print('Connection Timeout: $timeout');
    });
    print(socket!.connected);
    socket!.on('userOnline', (userId) {
      if (userId == widget.user.id) {
        setState(() {
          isUserOnline = true;
        });
      }
    });

    socket!.on('userOffline', (userId) {
      if (userId == widget.user.id) {
        setState(() {
          isUserOnline = false;
        });
      }
    });
  }

  void sendMessage(String message, String sourceId, String targetId) {
    if (chat == null) {
      // Chat is not fetched yet, do not send the message
      return;
    }

    try {
      setMessage(currentUser.id, message);
      socket!.emit("message", {
        "message": message,
        "sourceId": sourceId,
        "targetId": targetId,
      });

      print('Sending message: $message');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void setMessage(String type, String message) {
    if (chat == null) {
      // Chat is not fetched yet, do not add the message
      return;
    }

    MessageModel messageModel = MessageModel(
      user: type == "destination" ? widget.user.id : currentUser.id,
      chat: chat!.id,
      message: message,
      time: DateTime.now().toString().substring(10, 16),
    );

    setState(() {
      messages.add(messageModel);
    });

    _scrollToBottom(); // Scroll to the bottom when a new message is added
  }

  @override
  Widget build(BuildContext context) {
    if (!_isChatFetched) {
      // Fetch the chat data only if it's not already fetched
      return FutureBuilder<ChatModel>(
        future: fetchChat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: _themeMode == ThemeMode.dark
                  ? Colors.grey[900]
                  : Colors.white,
              appBar: buildAppBar(),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Scaffold(
              backgroundColor: _themeMode == ThemeMode.dark
                  ? Colors.grey[900]
                  : Colors.white,
              appBar: buildAppBar(),
              body: Center(
                child: Text("Error loading chat"),
              ),
            );
          } else {
            chat = snapshot.data;
            _isChatFetched =
                true; // Set the flag to true after fetching the chat

            return buildChatScreen(); // Call a separate function to build the chat screen
          }
        },
      );
    } else {
      // If chat data is already fetched, build the chat screen directly
      return buildChatScreen();
    }
  }

  Widget buildChatScreen() {
    return Scaffold(
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      appBar: buildAppBar(),
      body: WillPopScope(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  controller:
                      _scrollController, // Assign the ScrollController to the ListView
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    if (messages[index].user == currentUser.id) {
                      return OwnMessageCard(
                        messageModel: messages[index],
                        themeMode: _themeMode,
                      );
                    } else {
                      return ReplyCard(messageModel: messages[index]);
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10 / 2,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 32,
                    color: Background.withOpacity(0.08),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10 * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  isEmojiVisible.value = !isEmojiVisible.value;
                                  focusNode.unfocus();
                                  focusNode.canRequestFocus = true;
                                },
                                icon: Icon(
                                  Icons.sentiment_satisfied_alt_outlined,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.64),
                                )),
                            const SizedBox(width: 10 / 4),
                            Expanded(
                              child: TextField(
                                focusNode: focusNode,
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText:
                                      AppLocalizations.of(context)!.typeChat,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10 / 4),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!
                                    .withOpacity(0.64),
                              ),
                              onPressed: () {
                                final message = _messageController.text;
                                sendMessage(
                                    message, currentUser.id, widget.user.id);

                                print("chatId: " + chat!.id);
                                chatController.saveMessage(
                                    chat!.id, currentUser.id, message);

                                _messageController.clear();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Offstage(
                offstage: !isEmojiVisible.value,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    },
                    onBackspacePressed: () {},
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.30
                              : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      recentTabBehavior: RecentTabBehavior.RECENT,
                      recentsLimit: 28,
                      replaceEmojiOnLimitExceed: false,
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      loadingIndicator: const SizedBox.shrink(),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                      checkPlatformCompatibility: true,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        onWillPop: () {
          if (isEmojiVisible.value) {
            isEmojiVisible.value = false;
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
      ),
    );
  }

  Future<ChatModel> fetchChat() async {
    print("fetchChat");
    chat = await chatController.getChat(currentUser.id, widget.user.id);

    print(chat);
    print(chat?.id); // Update references to chat to use chat!

    // Call the fetchMessages() function to get the messages for this chat
    await fetchMessages();
    //isUserOnline = await chatController.isUserOnline(widget.user.id);
    setState(() {
      _isChatFetched = true; // Set the flag to true after fetching the chat
    });
    socket!.emit('userOnline', currentUser.id);
    try {
      final response =
          await http.get(Uri.parse(localurl + '/api/users/' + widget.user.id));
      final responseData = json.decode(response.body);
      setState(() {
        isUserOnline = responseData['online'];
      });
    } catch (error) {
      print('Error fetching user online status: $error');
    }

    return chat!;
  }

  Future<void> fetchMessages() async {
    try {
      print("fetchMessages");
      // Assuming you have chat.id available here
      List<MessageModel> retrievedMessages =
          await chatController.getMessages(chat!.id);
      print(retrievedMessages);
      print(retrievedMessages.length);

      setState(() {
        messages = retrievedMessages; // Update the messages list

        // Call _scrollToBottom only once after the messages are fetched and ListView is rebuilt
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      });
    } catch (error) {
      print("Error fetching messages: $error");
    }
  }

  void _scrollToBottom() {
    // Scroll to the bottom of the ListView with animation
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: ButtonBlack),
        onPressed: () {
          print("chat: " + chat.toString());
          if (messages.length == 0) {
            print("chat is null");
            chatController.deleteChat(chat?.id);
            setState(() {
              chat = null; // Set the chat to null to trigger UI update
            });
          }
          Navigator.pop(context);
        },
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Background,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(Profile(widget.user));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  widget.user.imageUrl), // Replace AssetImage with NetworkImage
              backgroundColor: isUserOnline == true
                  ? Colors.green
                  : Colors.grey, // Set background color based on online status
              radius: 20,
              child: isUserOnline == true
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 5,
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 5,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 10 * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(Profile(widget.user));
                },
                child: Text(
                  widget.user.name,
                  style: TextStyle(fontSize: 16, color: ButtonBlack),
                ),
              ),
              Text(
                isUserOnline == true ? "Online" : "Offline",
                style: TextStyle(
                    fontSize: 12,
                    color: isUserOnline == true ? Colors.green : Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
