import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/Chat.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/screens/messages.dart';
import 'package:frontend/widgets/comment_post.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/edit_blog.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/controllers/blog_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/controllers/chat_controller.dart';
import 'package:frontend/controllers/report_controller.dart';
import 'package:frontend/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlogScreen extends StatefulWidget {
  final Blog blog;

  BlogScreen(this.blog);

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  BlogController blogController = Get.put(BlogController());

  ChatController chatController = Get.put(ChatController());
  ReportController reportController = ReportController();

  bool isOwner = false;
  bool hasLiked = false;
  bool _flagLiked = false;

  ThemeMode _themeMode = ThemeMode.system; // Initialize with system mode

  @override
  void initState() {
    super.initState();
    checkIsOwner();
    checkHasLiked();
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

  Future<void> checkIsOwner() async {
    var url = Uri.parse('http://10.0.2.2:5432/api/blogs/' + widget.blog.id);
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      currentUser.username == data['author']['username']
          ? isOwner = true
          : isOwner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(HomeScreen()),
        ),
        title: Text(
          widget.blog.title,
          style: TextStyle(color: ButtonBlack),
        ),
        iconTheme: IconThemeData(color: ButtonBlack),
        backgroundColor: Background,
        actions: [
          // Add a report button to the app bar
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () {
              sendReportBlog();
            },
          ),
        ],
      ),
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: _themeMode == ThemeMode.dark
                    ? Colors.grey[900]
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      widget.blog.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.network(
                          widget.blog.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          foregroundColor: ButtonBlack,
                          onPressed: () => {
                            setState(() {
                              _flagLiked = !_flagLiked;
                            }),
                            if (_flagLiked)
                              {
                                blogController.deleteUserLike(widget.blog.id),
                              }
                            else
                              {
                                blogController.addUserLike(widget.blog.id),
                              },
                          },
                          child: Icon(
                            _flagLiked
                                ? FontAwesomeIcons.heartBroken
                                : FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            widget.blog.author["imageUrl"],
                            width: 50,
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.person),
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .viewProfile),
                                        onTap: () {
                                          navigateToUserProfile(
                                              widget.blog.author["_id"]);
                                        },
                                      ),
                                      if (currentUser.id !=
                                          widget.blog.author["_id"])
                                        ListTile(
                                          leading: Icon(Icons.message),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .sendMessage),
                                          onTap: () {
                                            // Handle the "Send Message" option
                                            // Show a dialog or navigate to the messaging screen
                                            print("Sending message to user");

                                            sendMessageToUser(
                                                widget.blog.author["_id"]);
                                          },
                                        ),
                                      if (currentUser.id !=
                                          widget.blog.author["_id"])
                                        ListTile(
                                          leading: Icon(Icons.report),
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .reportUser),
                                          onTap: () {
                                            sendReportUser();
                                            // Close the bottom sheet
                                          },
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!
                                .by(widget.blog.author["username"]),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.blog.date,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(right: 50, left: 50),
                    child: Text(
                      widget.blog.body_text,
                      style: TextStyle(
                        fontSize: 18,
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.comments,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Comment section
                  Card(
                    color: Background,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: CommentPost(widget.blog),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isOwner)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _themeMode == ThemeMode.dark
                      ? Colors.grey[800]
                      : Colors.black,
                  foregroundColor: Background),
              onPressed: () async {
                final updatedBlog = await Get.to(EditBlog(widget.blog));
                if (updatedBlog != null) {
                  setState(() {
                    // Update the blog object with the new data
                    widget.blog.title = updatedBlog.title;
                    widget.blog.description = updatedBlog.description;
                    widget.blog.body_text = updatedBlog.body_text;
                    widget.blog.imageUrl = updatedBlog.imageUrl;
                  });
                }
              },
              child: Icon(Icons.edit),
            ),
        ],
      ),
    );
  }

  Future<void> checkHasLiked() async {
    BlogController blogController = await Get.put(BlogController());

    bool _hasLiked = await blogController.userHasLiked(widget.blog.id);

    if (_hasLiked == true) {
      setState(() {
        _flagLiked = false;
        //listParticipants += 1;
      });
    } else {
      setState(() {
        _flagLiked = true;
        //listParticipants -= 1;
      });
    }
  }

  Future<void> navigateToUserProfile(idUser) async {
    final data =
        await http.get(Uri.parse('http://10.0.2.2:5432/api/users/' + idUser));
    var jsonData = json.decode(data.body);

    User user = User(
      id: jsonData["_id"],
      username: jsonData["username"],
      password: jsonData["password"],
      email: jsonData["email"],
      date: jsonData["date"],
      name: jsonData["name"],
      imageUrl: jsonData["imageUrl"],
      backgroundImageUrl: jsonData["backgroundImageUrl"],
      about: jsonData["about"],
      meetingsFollowed: jsonData["meetingsFollowed"],
      followers: jsonData["followers"] ??
          [], // This is a list of IDs, so it should be initialized as an empty list
      following: jsonData["following"] ?? [],
    );

    Get.to(Profile(user));
  }

  Future<void> sendMessageToUser(recipientId) async {
    print("Sending message to user with ID: " + recipientId);
    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/users/' + recipientId));
    var jsonData = json.decode(data.body);

    User user = User(
      id: jsonData["_id"],
      username: jsonData["username"],
      password: jsonData["password"],
      email: jsonData["email"],
      date: jsonData["date"],
      name: jsonData["name"],
      imageUrl: jsonData["imageUrl"],
      backgroundImageUrl: jsonData["backgroundImageUrl"],
      about: jsonData["about"],
      meetingsFollowed: jsonData["meetingsFollowed"],
      followers: jsonData["followers"] ?? [],
      following: jsonData["following"] ?? [],
    );

    ChatModel? chat = await chatController.getChat(currentUser.id, user.id);
    if (chat == null) {
      // If the chat is null, it means no chat exists, so we create a new chat
      chatController.createChat(currentUser.id, user.id);
    }

    Get.to(MessagesScreen(user));
    // Perform the logic for sending a message to a user
  }

  void sendReportUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeMode == ThemeMode.dark
              ? Color.fromARGB(255, 72, 70, 70)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(AppLocalizations.of(context)!.report,
              style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black)),
          content: Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              children: [
                TextField(
                  controller: reportController.reasonController,
                  style: TextStyle(
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.reasonReport,
                    hintStyle: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (reportController.reasonController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!.plsReason,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: ButtonBlack,
                      textColor: Background,
                      fontSize: 16.0);
                } else {
                  await reportController
                      .createReport("User", widget.blog.author["_id"])
                      .then((value) {
                    if (value == "Report saved") {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.reportSent,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: ButtonBlack,
                          textColor: Background,
                          fontSize: 16.0);
                      Get.back();
                    } else {
                      print(value);
                      Fluttertoast.showToast(
                          msg: value,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: ButtonBlack,
                          textColor: Background,
                          fontSize: 16.0);
                    }
                  });
                }
              },
              child: Text(AppLocalizations.of(context)!.confirm,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void sendReportBlog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeMode == ThemeMode.dark
              ? Color.fromARGB(255, 72, 70, 70)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(AppLocalizations.of(context)!.report,
              style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black)),
          content: Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              children: [
                TextField(
                  controller: reportController.reasonController,
                  style: TextStyle(
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.reasonReport,
                    hintStyle: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (reportController.reasonController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!.plsReason,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: ButtonBlack,
                      textColor: Background,
                      fontSize: 16.0);
                } else {
                  await reportController
                      .createReport("Blog", widget.blog.id)
                      .then((value) {
                    if (value == "Report saved") {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.reportSent,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: ButtonBlack,
                          textColor: Background,
                          fontSize: 16.0);
                      Get.back();
                    } else {
                      print(value);
                      Fluttertoast.showToast(
                          msg: value,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: ButtonBlack,
                          textColor: Background,
                          fontSize: 16.0);
                    }
                  });
                }
              },
              child: Text(AppLocalizations.of(context)!.confirm,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
