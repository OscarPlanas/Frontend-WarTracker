import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/blog_controller.dart';
import 'package:frontend/controllers/chat_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/Chat.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/models/comment.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/messages.dart';
import 'package:frontend/screens/profile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CommentPost extends StatefulWidget {
  final Blog blog; // New parameter to hold the blog ID

  CommentPost(this.blog);

  @override
  _CommentPostState createState() => _CommentPostState();
}

class _CommentPostState extends State<CommentPost> {
  var blog;
  var commentID;

  BlogController blogController = Get.put(BlogController());

  List<Comments> comments = []; // Updated to store comments
  final commentController = TextEditingController();

  ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    blogController.getBlogs();
    blog = widget.blog;
    print(blog.id);

    // Call your function to fetch comments and update the state
    fetchComments();
  }

  Future<void> fetchComments() async {
    List<Comments> fetchedComments = await BlogController().getComments(blog
        .id); // Replace `yourController` with an instance of your controller class and `idBlog` with the desired blog ID
    setState(() {
      comments = fetchedComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 10.0, right: 184, top: 10, bottom: 10),
              child: Text(
                "Write a comment...",
                style: GoogleFonts.roboto(
                  backgroundColor: Colors.white,
                  fontSize: 16,
                  color: ButtonBlack,
                ),
              ),
            ),
          ),
          onTap: () {
            _showCommentInputScreen();
          },
        ),
        Divider(
          thickness: 0.7,
          color: ButtonBlack,
        ),
        SizedBox(height: 20),
        // Display the comments
        for (var comment in comments) ...[
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            color: Theme.of(context).cardColor,
            elevation: 0.8,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: double.infinity,
              ),
              margin: EdgeInsets.only(right: 16, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4, top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Container(
                                  margin: EdgeInsets.only(right: 8.0),
                                  width: 20,
                                  height: 20,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: new DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        comment.owner['imageUrl'],
                                        scale: 1.0,
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              WidgetSpan(
                                child: GestureDetector(
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
                                                title: Text('View Profile'),
                                                onTap: () {
                                                  // Handle the "View Profile" option
                                                  // Navigate to the user's profile screen
                                                  //Navigator.pop(
                                                  //  context); // Close the bottom sheet

                                                  navigateToUserProfile(
                                                      comment.owner['_id']);
                                                },
                                              ),
                                              if (comment.owner['_id'] !=
                                                  currentUser.id)
                                                ListTile(
                                                  leading: Icon(Icons.message),
                                                  title: Text('Send Message'),
                                                  onTap: () {
                                                    // Handle the "Send Message" option
                                                    // Show a dialog or navigate to the messaging screen
                                                    print(
                                                        "Sending message to user");

                                                    sendMessageToUser(
                                                        comment.owner['_id']);
                                                  },
                                                ),
                                              if (comment.owner['_id'] !=
                                                  currentUser.id)
                                                ListTile(
                                                  leading: Icon(Icons.report),
                                                  title: Text('Report User'),
                                                  onTap: () {
                                                    // Handle the "Report User" option
                                                    // Show a dialog or perform the reporting logic
                                                    Navigator.pop(
                                                        context); // Close the bottom sheet
                                                  },
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: comment.owner['username'],
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: ButtonBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    comment.content,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Theme.of(context).disabledColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              comment.repliesVisible = !comment.repliesVisible;
                              // comment.repliesVisible = !comment.repliesVisible;

                              print('expand/collapse replies');
                              // Handle the click to expand/collapse the replies
                              // Set a boolean flag to control the expansion state
                            });
                          },
                          child: Text.rich(
                            TextSpan(
                                text: comment.repliesVisible
                                    ? "Hide replies"
                                    : 'Show ${comment.replies.length} replies',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.blue,
                                )),
                          ),
                        ),
                        SizedBox(width: 30),
                        InkWell(
                          onTap: () async {
                            if (comment.liked) {
                              print("Ya le ha dado me gusta");
                              blogController.cancelLikeToComment(comment.id);
                              //cancelLikeFromComment(comment.id);
                              setState(() {
                                comment.liked = false;
                                comment.likes.length -= 1;
                              });
                            } else {
                              print("No le ha dado me gusta");
                              if (comment.disliked) {
                                blogController
                                    .cancelDislikeToComment(comment.id);
                                setState(() {
                                  comment.disliked = false;
                                  comment.dislikes.length -= 1;
                                });
                              }
                              blogController.addLikeToComment(comment.id);
                              setState(() {
                                comment.liked = true;
                                comment.likes.length += 1;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 2.0),
                                child: Icon(
                                  Icons.thumb_up,
                                  size: 15.0,
                                  color: comment.liked
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                              Text(
                                comment.likes.length.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: comment.liked
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: 30), // Adjust the spacing between the icons
                        InkWell(
                          onTap: () async {
                            if (comment.disliked) {
                              print("Ya le ha dado no me gusta");
                              blogController.cancelDislikeToComment(comment.id);
                              //cancelLikeFromComment(comment.id);
                              setState(() {
                                comment.disliked = false;
                                comment.dislikes.length -= 1;
                              });
                            } else {
                              print("No le ha dado no me gusta");
                              if (comment.liked) {
                                blogController.cancelLikeToComment(comment.id);
                                setState(() {
                                  comment.liked = false;
                                  comment.likes.length -= 1;
                                });
                              }
                              blogController.addDislikeToComment(comment.id);
                              setState(() {
                                comment.disliked = true;
                                comment.dislikes.length += 1;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 2.0),
                                child: Icon(
                                  Icons.thumb_down,
                                  size: 15.0,
                                  color: comment.disliked
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              Text(
                                comment.dislikes.length.toString(),
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: comment.disliked
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 40),
                        InkWell(
                          onTap: () {
                            _showReplyInputScreen(comment.id);
                            // Handle the click event here
                            // You can navigate to another screen or perform any desired action
                          },
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.labelLarge,
                              children: [
                                WidgetSpan(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 2.0),
                                    child: Icon(
                                      Icons.reply,
                                      size: 15.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: "Reply",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (comment.repliesVisible)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...comment.replies.map<Widget>((replyDetails) {
                          String replyOwner = replyDetails['owner']['username'];
                          String replyId = replyDetails['owner']['_id'];
                          String replyContent = replyDetails['content'];
                          String replyLike =
                              replyDetails['likes'].length.toString();
                          String replyDislike =
                              replyDetails['dislikes'].length.toString();

                          String replyImage = replyDetails['owner']['imageUrl'];

                          bool isReplyLiked = replyDetails['likes'].contains(
                              currentUser
                                  .id); // Check if the user has liked the reply
                          bool isReplyDisliked = replyDetails['dislikes']
                              .contains(currentUser
                                  .id); // Check if the user has disliked the reply

                          return Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                            ),
                            color: Theme.of(context).cardColor,
                            elevation: 0.8,
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              margin: EdgeInsets.only(right: 16, left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 4, top: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 8.0),
                                                  width: 20,
                                                  height: 20,
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    image: new DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        replyImage,
                                                        scale: 1.0,
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              ListTile(
                                                                leading: Icon(
                                                                    Icons
                                                                        .person),
                                                                title: Text(
                                                                    'View Profile'),
                                                                onTap: () {
                                                                  navigateToUserProfile(
                                                                      replyId);
                                                                },
                                                              ),
                                                              if (replyId !=
                                                                  currentUser
                                                                      .id)
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .message),
                                                                  title: Text(
                                                                      'Send Message'),
                                                                  onTap: () {
                                                                    // Handle the "Send Message" option
                                                                    // Show a dialog or navigate to the messaging screen
                                                                    print(
                                                                        "Sending message to user");

                                                                    sendMessageToUser(
                                                                        replyId);
                                                                  },
                                                                ),
                                                              if (replyId !=
                                                                  currentUser
                                                                      .id)
                                                                ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .report),
                                                                  title: Text(
                                                                      'Report User'),
                                                                  onTap: () {
                                                                    // Handle the "Report User" option
                                                                    // Show a dialog or perform the reporting logic
                                                                    Navigator.pop(
                                                                        context); // Close the bottom sheet
                                                                  },
                                                                ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: replyOwner,
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 16,
                                                        color: ButtonBlack,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    replyContent,
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 10, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (isReplyLiked) {
                                                // If already liked, cancel the like
                                                blogController
                                                    .cancelLikeToComment(
                                                        replyDetails['_id']);
                                                replyDetails['likes']
                                                    .remove(currentUser.id);
                                              } else {
                                                // If not liked, add the like
                                                if (isReplyDisliked) {
                                                  blogController
                                                      .cancelDislikeToComment(
                                                          replyDetails['_id']);
                                                  replyDetails['dislikes']
                                                      .remove(currentUser.id);
                                                }
                                                blogController.addLikeToComment(
                                                    replyDetails['_id']);
                                                replyDetails['likes']
                                                    .add(currentUser.id);
                                              }
                                            });
                                          },
                                          child: Text.rich(
                                            TextSpan(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                              children: [
                                                WidgetSpan(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 2.0),
                                                    child: Icon(
                                                      isReplyLiked
                                                          ? Icons.thumb_up
                                                          : Icons.thumb_up_alt,
                                                      size: 15.0,
                                                      color: isReplyLiked
                                                          ? Colors.green
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: replyLike,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14,
                                                    color: isReplyLiked
                                                        ? Colors.green
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 30),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (isReplyDisliked) {
                                                // If already liked, cancel the like
                                                blogController
                                                    .cancelDislikeToComment(
                                                        replyDetails['_id']);
                                                replyDetails['dislikes']
                                                    .remove(currentUser.id);
                                              } else {
                                                // If not liked, add the like
                                                if (isReplyLiked) {
                                                  blogController
                                                      .cancelLikeToComment(
                                                          replyDetails['_id']);
                                                  replyDetails['likes']
                                                      .remove(currentUser.id);
                                                }
                                                blogController
                                                    .addDislikeToComment(
                                                        replyDetails['_id']);
                                                replyDetails['dislikes']
                                                    .add(currentUser.id);
                                              }
                                            });
                                          },
                                          child: Text.rich(
                                            TextSpan(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                              children: [
                                                WidgetSpan(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        right: 2.0),
                                                    child: Icon(
                                                      isReplyLiked
                                                          ? Icons.thumb_down
                                                          : Icons
                                                              .thumb_down_alt,
                                                      size: 15.0,
                                                      color: isReplyDisliked
                                                          ? Colors.red
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: replyDislike,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14,
                                                    color: isReplyDisliked
                                                        ? Colors.red
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    )
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          color: Theme.of(context).cardColor,
          elevation: 0.8,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: double.infinity,
            ),
            margin: EdgeInsets.only(right: 16, left: 16),
          ),
        ),
      ],
    );
  }

  void _showCommentInputScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Write a comment'),
          content: TextField(
            controller: blogController.commentController,
            decoration: InputDecoration(
              hintText: 'Enter your comment...',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Background),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Background, foregroundColor: ButtonBlack),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Post'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Background, foregroundColor: ButtonBlack),
              onPressed: () {
                if (blogController.commentController.text.isNotEmpty) {
                  //blogController.addComment(blog.id);
                  setState(() {
                    blogController.addComment(blog.id);
                    fetchComments();
                  });
                  Navigator.pop(context);
                } else {
                  // Show an error message or perform some other action if the comment text is empty
                  // For example, you can display a snackbar:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a comment before posting.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showReplyInputScreen(idComment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Write a reply'),
          content: TextField(
            controller: blogController.replyController,
            decoration: InputDecoration(
              hintText: 'Enter your reply...',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Background),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Background, foregroundColor: ButtonBlack),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Post'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Background, foregroundColor: ButtonBlack),
              onPressed: () {
                if (blogController.replyController.text.isNotEmpty) {
                  //blogController.addComment(blog.id);
                  setState(() {
                    blogController.addReply(idComment);
                    fetchComments();
                  });
                  Navigator.pop(context);
                } else {
                  // Show an error message or perform some other action if the comment text is empty
                  // For example, you can display a snackbar:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a comment before posting.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> navigateToUserProfile(idUser) async {
    final data =
        await http.get(Uri.parse('http://10.0.2.2:5432/api/users/' + idUser));
    var jsonData = json.decode(data.body);
    print(jsonData);
    User user = User(
      id: jsonData["_id"],
      username: jsonData["username"],
      password: jsonData["password"],
      email: jsonData["email"],
      name: jsonData["name"],
      date: jsonData["date"],
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
}
