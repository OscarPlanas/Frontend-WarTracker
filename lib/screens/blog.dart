import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/widgets/comment_post.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/edit_blog.dart';
import 'package:frontend/screens/home.dart';

class BlogScreen extends StatefulWidget {
  final Blog blog;

  BlogScreen(this.blog);

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
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
      ),
      backgroundColor: Background,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    child: Image.asset("assets/images/laptopplaceholder.png"),
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
                          child: Image.asset(
                            "assets/images/groguplaceholder.png",
                            width: 50,
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "By ${widget.blog.author["username"]}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Comments",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
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
          //if (isOwner)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ButtonBlack, foregroundColor: Background),
            onPressed: () async {
              setState(() {
                // Refresh the page
                Get.to(EditBlog(widget.blog));
              });
            },
            child: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
