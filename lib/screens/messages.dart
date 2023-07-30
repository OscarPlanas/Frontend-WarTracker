import 'package:flutter/material.dart';
import 'package:frontend/components/Messages/OwnMessageCard.dart';
import 'package:frontend/components/Messages/ReplyCard.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/chat_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/Chat.dart';
import 'package:frontend/models/message.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/chats.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  @override
  void dispose() {
    // Dispose the ScrollController when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    connect();
    if (!_isChatFetched) {
      fetchChat();
    }
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
              appBar: buildAppBar(),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Scaffold(
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
      appBar: buildAppBar(),
      body: Column(
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
                    return OwnMessageCard(messageModel: messages[index]);
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
                  color: const Color(0xFF087949).withOpacity(0.08),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  const Icon(Icons.mic, color: Colors.green),
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
                          Icon(
                            Icons.sentiment_satisfied_alt_outlined,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.64),
                          ),
                          const SizedBox(width: 10 / 4),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: "Type message",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.attach_file,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.64),
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
        ],
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

    setState(() {
      _isChatFetched = true; // Set the flag to true after fetching the chat
    });

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
        onPressed: () => Get.offAll(ChatsScreen()),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Background,
      title: Row(
        children: [
          //const BackButton(),
          CircleAvatar(
            backgroundImage: NetworkImage(
                widget.user.imageUrl), // Replace AssetImage with NetworkImage
          ),
          const SizedBox(width: 10 * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(fontSize: 16, color: ButtonBlack),
              ),
              Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_phone, color: ButtonBlack),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam, color: ButtonBlack),
          onPressed: () {},
        ),
        const SizedBox(width: 10 / 2),
      ],
    );
  }
}
