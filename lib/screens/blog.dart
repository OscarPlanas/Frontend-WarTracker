import 'package:flutter/material.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/constants.dart';

class BlogScreen extends StatelessWidget {
  final Blog blog;

  BlogScreen(this.blog);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title, style: TextStyle(color: ButtonBlack)),
        iconTheme: IconThemeData(color: ButtonBlack),
        backgroundColor: Background,
      ),
      backgroundColor: Background,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(children: <Widget>[
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    blog.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  child: Image.network("https://picsum.photos/250?image=9"),
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
                          "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/baby-yoda-nombre-1606753349.jpg?crop=0.75xw:1xh;center,top&resize=1200:*",
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("By ${blog.author["username"]} ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text(DateTime.now().toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(right: 50, left: 50),
                  child: Text(
                    blog.body_text,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(238, 241, 242, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "comment...",
                            hintStyle: TextStyle(fontSize: 18)),
                      ),
                    )),
                SizedBox(height: 20),
              ]),
            ),
          ],
        ),
      )),
    );
  }
}
