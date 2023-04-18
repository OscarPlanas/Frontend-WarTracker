import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/blog.dart';
import 'package:frontend/screens/home.dart';
import 'package:get/get.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  //final String authorName, title, desc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.offAll(HomeScreen()),
          ),
          title: Text("Create blog", style: TextStyle(color: ButtonBlack)),
          iconTheme: IconThemeData(color: ButtonBlack),
          backgroundColor: Background,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.offAll(HomeScreen());
          },
          child: Icon(Icons.add, color: ButtonBlack),
          backgroundColor: Background,
        ),
        body: Container(
            child: ListView(children: <Widget>[
          SizedBox(height: 10),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6)),
              width: MediaQuery.of(context).size.width,
              child: Icon(Icons.add_a_photo, color: Colors.black)),
          SizedBox(height: 8),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: "Blog Title"),
                  onChanged: (val) {
                    //title = val;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Blog Description"),
                  onChanged: (val) {
                    //desc = val;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Write your blog here"),
                  onChanged: (val) {
                    //body = val;
                  },
                ),
              ]))
        ])));
  }
}
