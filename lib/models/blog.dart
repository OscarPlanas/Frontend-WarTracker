import 'package:flutter/material.dart';

class Blog {
  //final String id;
  final String title;
  final String description;
  final String body_text;
  //final String image;
  //final String author;
  //final String date;

  Blog({
    //required this.id,
    required this.title,
    required this.description,
    //required this.image,
    required this.body_text,
    //required this.author,
    //required this.date
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      //id: json['id'],
      title: json['title'],
      description: json['description'],
      //image: json['image'],
      body_text: json['body_text'],
      //author: json['author'],
      //date: json['date']
    );
  }
}
