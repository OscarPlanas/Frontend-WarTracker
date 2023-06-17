import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/data/data.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/models/comment.dart';
import 'package:frontend/controllers/meeting_controller.dart';
import 'package:frontend/models/meeting.dart';
import 'package:get/get.dart';

class CommentMeeting extends StatefulWidget {
  final Meeting meeting; // New parameter to hold the meeting ID

  CommentMeeting(this.meeting);

  @override
  _CommentMeetingState createState() => _CommentMeetingState();
}

class _CommentMeetingState extends State<CommentMeeting> {
  var meeting;
  var commentID;

  MeetingController meetingController = Get.put(MeetingController());

  List<Comments> comments = []; // Updated to store comments
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    meetingController.getMeetings();
    meeting = widget.meeting;
    print(meeting.id);

    // Call your function to fetch comments and update the state
    fetchComments();
  }

  Future<void> fetchComments() async {
    List<Comments> fetchedComments =
        await MeetingController().getComments(meeting.id);
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
                  EdgeInsets.only(left: 10.0, right: 120, top: 10, bottom: 10),
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
                                        'https://naijacrawl.com/logo/logo.webp',
                                        scale: 1.0,
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: comment.owner['username'],
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: ButtonBlack,
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

                              print('expand/collapse replies');
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
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () async {
                            if (comment.liked) {
                              print("Ya le ha dado me gusta");
                              meetingController.cancelLikeToComment(comment.id);

                              setState(() {
                                comment.liked = false;
                                comment.likes.length -= 1;
                              });
                            } else {
                              print("No le ha dado me gusta");
                              if (comment.disliked) {
                                meetingController
                                    .cancelDislikeToComment(comment.id);
                                setState(() {
                                  comment.disliked = false;
                                  comment.dislikes.length -= 1;
                                });
                              }
                              meetingController.addLikeToComment(comment.id);
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
                            width: 20), // Adjust the spacing between the icons
                        InkWell(
                          onTap: () async {
                            if (comment.disliked) {
                              print("Ya le ha dado no me gusta");
                              meetingController
                                  .cancelDislikeToComment(comment.id);

                              setState(() {
                                comment.disliked = false;
                                comment.dislikes.length -= 1;
                              });
                            } else {
                              print("No le ha dado no me gusta");
                              if (comment.liked) {
                                meetingController
                                    .cancelLikeToComment(comment.id);
                                setState(() {
                                  comment.liked = false;
                                  comment.likes.length -= 1;
                                });
                              }
                              meetingController.addDislikeToComment(comment.id);
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
                        SizedBox(width: 35),
                        InkWell(
                          onTap: () {
                            _showReplyInputScreen(comment.id);
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
                          String replyContent = replyDetails['content'];
                          String replyLike =
                              replyDetails['likes'].length.toString();
                          String replyDislike =
                              replyDetails['dislikes'].length.toString();

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
                                                        'https://naijacrawl.com/logo/logo.webp',
                                                        scale: 1.0,
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: replyOwner,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                  color: ButtonBlack,
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
                                                meetingController
                                                    .cancelLikeToComment(
                                                        replyDetails['_id']);
                                                replyDetails['likes']
                                                    .remove(currentUser.id);
                                              } else {
                                                // If not liked, add the like
                                                if (isReplyDisliked) {
                                                  meetingController
                                                      .cancelDislikeToComment(
                                                          replyDetails['_id']);
                                                  replyDetails['dislikes']
                                                      .remove(currentUser.id);
                                                }
                                                meetingController
                                                    .addLikeToComment(
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
                                                meetingController
                                                    .cancelDislikeToComment(
                                                        replyDetails['_id']);
                                                replyDetails['dislikes']
                                                    .remove(currentUser.id);
                                              } else {
                                                // If not liked, add the like
                                                if (isReplyLiked) {
                                                  meetingController
                                                      .cancelLikeToComment(
                                                          replyDetails['_id']);
                                                  replyDetails['likes']
                                                      .remove(currentUser.id);
                                                }
                                                meetingController
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
            controller: meetingController.commentController,
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
                if (meetingController.commentController.text.isNotEmpty) {
                  setState(() {
                    meetingController.addComment(meeting.id);
                    fetchComments();
                  });
                  Navigator.pop(context);
                } else {
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
            controller: meetingController.replyController,
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
                if (meetingController.replyController.text.isNotEmpty) {
                  setState(() {
                    meetingController.addReply(idComment);
                    fetchComments();
                  });
                  Navigator.pop(context);
                } else {
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
}
