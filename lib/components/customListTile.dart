import 'package:frontend/constants.dart';
import 'package:frontend/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/blog.dart';

Widget customListTile(Blog blog, BuildContext context, ThemeMode themeMode) {
  Color? backgroundColor =
      themeMode == ThemeMode.dark ? Colors.grey[800] : Colors.white;

  Color? textColor = themeMode == ThemeMode.dark ? Colors.white : Colors.black;

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlogScreen(blog),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
          ),
        ],
        // Add a border
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(blog.imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Background,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              blog.title,
              style: TextStyle(
                color: ButtonBlack,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            blog.description,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: textColor,
            ),
          ),
        ],
      ),
    ),
  );
}
