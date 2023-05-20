import 'dart:convert';

import 'package:frontend/models/meeting.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:frontend/data/data.dart';

class MeetingController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final LocalStorage storage = new LocalStorage('My App');

  Future<List<Meeting>> getMeetings() async {
    List<Meeting> meetings = [];
    final data = await http.get(Uri.parse('http://10.0.2.2:5432/api/meetings'));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      //print(data.body);
      Meeting meeting = Meeting(
          id: u["_id"],
          title: u["title"],
          description: u["description"],
          organizer: u["organizer"],
          date: u["date"],
          //image: u["image"],
          location: u["location"],
          registration_fee: u["registration_fee"],
          participants: u["participants"]);
      //var owner = json.decode(blog.author.toString());
      meetings.add(meeting);
    }
    //print(blogs.length);
    return meetings;
  }

  Future<Meeting> getOneMeeting(idMeeting) async {
    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/meetings/' + idMeeting));

    var jsonData = json.decode(data.body);

    Meeting meeting = Meeting(
        id: jsonData["_id"],
        title: jsonData["title"],
        description: jsonData["description"],
        organizer: jsonData["organizer"],
        date: jsonData["date"],
        //image: u["image"],
        location: jsonData["location"],
        registration_fee: jsonData["registration_fee"],
        participants: jsonData["participants"]);

    return meeting;
  }

  void addParticipant(idMeeting) async {
    print("Vemos id del jugador a unirse " + currentUser.id);
    print("Vemos id del meeting a unirse " + idMeeting);

    await http.put(
      Uri.parse('http://10.0.2.2:5432/api/meetings/join/' +
          currentUser.id +
          '/' +
          idMeeting),
    );

    print("ha pasado " + currentUser.id);
  }

  void deleteParticipant(idMeeting) async {
    print("Vemos id del jugador a desapuntarse " + currentUser.id);
    print("Vemos id del meeting a desapuntarse " + idMeeting);
    await http.put(
      Uri.parse('http://10.0.2.2:5432/api/meetings/leave/' +
          currentUser.id +
          '/' +
          idMeeting),
    );
    print("ha pasado para desapuntarse " + currentUser.id);
  }

  Future<bool> userIsParticipant(idMeeting) async {
    bool isParticipant = false;
    Meeting meeting = await getOneMeeting(idMeeting);
    var a = meeting.participants;

    print(a.map((participants) => participants["_id"]).toList());

    print(a
        .map((participants) => participants["_id"])
        .toList()
        .contains(currentUser.id));
    print("IMPORTANTE");
    if (a
        .map((participants) => participants["_id"])
        .toList()
        .contains(currentUser.id)) {
      isParticipant = true;
    }

    print(isParticipant);
    return isParticipant;
  }
}
