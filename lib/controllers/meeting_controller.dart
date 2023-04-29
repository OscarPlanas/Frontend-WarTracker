import 'dart:convert';

//import 'package:frontend/models/blogplaceholder.dart';
import 'package:date_format/date_format.dart';
import 'package:frontend/models/meeting.dart';

import 'package:frontend/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';
import 'package:frontend/controllers/blog_controller.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/data/data.dart';

class MeetingController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final LocalStorage storage = new LocalStorage('My App');

  Future<String> createBlog() async {
    try {
      var headers = {'Content-Type': 'application/json'};

      print('Crear blog');
      var url = Uri.parse('http://10.0.2.2:5432/api/blogs');
      Map body = {
        'title': titleController.text.trim(),
        'description': descriptionController.text,
        'body_text': contentController.text,
        'author': currentUser.id,
        'date': formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]),
      };
      print("as");
      print(currentUser.id);
      print("as");

      print(body['author']);
      print('datos de crear blog');
      print(body);

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      print('response de crear blog');
      print(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("correcto");
        if (json['status'] == "Blog saved") {
          titleController.clear();
          descriptionController.clear();
          contentController.clear();
          Get.off(HomeScreen());
        } else if (json['status'] == false) {
          var message = jsonDecode(response.body)['message'];
          return message;
        }
      } else {
        var message2 = jsonDecode(response.body)['message'];
        return message2;
      }
      return "Unknown Error Occured";
    } catch (error) {
      Get.back();
      return "Unknown Error Occured";
    }
  }

  Future<List<Meeting>> getMeetings() async {
    List<Meeting> meetings = [];
    final data = await http.get(Uri.parse('http://10.0.2.2:5432/api/meetings'));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      //print(data.body);
      Meeting meeting = Meeting(
          //id: u["id"],
          title: u["title"],
          description: u["description"],
          organizer: u["organizer"],
          date: u["date"],
          //image: u["image"],
          location: u["location"],
          registration_fee: u["registration_fee"]);
      //var owner = json.decode(blog.author.toString());
      print("Vemos organizador del meeting " + meeting.organizer['username']);
      print("Vemos date del meeting" + meeting.date);
      meetings.add(meeting);
    }
    //print(blogs.length);
    return meetings;
  }
}
