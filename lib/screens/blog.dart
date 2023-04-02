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
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network("https://picsum.photos/250?image=9", height: 300),
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  blog.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  blog.body_text,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],

            /*children: [
              Image.network(blog.image),
              SizedBox(
                height: 10,
              ),
              Text(
                blog.description,
                style: TextStyle(fontSize: 18),
              )
            ],*/
          )),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        color: Background,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage('assets/images/logoWelcome.png'),
            ),
            SizedBox(height: 8),
            Text('PlaceholderProfile',
                style: TextStyle(color: ButtonBlack, fontSize: 22)),
            Text('PlaceholderEmail',
                style: TextStyle(color: ButtonBlack, fontSize: 14)),
          ],
        ),
      );
}
