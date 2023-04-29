import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:intl/intl.dart';

class Meeting {
  //final String id;
  String title;
  String description;
  String date;
  Map<String, dynamic> organizer;
  String location;
  int registration_fee;
  //final String image;
  //final String date;

  Meeting(
      {
      //required this.id,
      required this.title,
      required this.description,
      //required this.image,
      required this.date,
      required this.organizer,
      required this.location,
      required this.registration_fee});

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
        //id: json['id'],
        title: json['title'],
        description: json['description'],
        //image: json['image'],
        date: json['date'],
        organizer: json['organizer'],
        location: json['location'],
        registration_fee: json['registration_fee']);
  }
}
