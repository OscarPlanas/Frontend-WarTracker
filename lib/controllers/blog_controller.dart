import 'dart:convert';

//import 'package:frontend/models/blogplaceholder.dart';
import 'package:frontend/models/blog.dart';

import 'package:frontend/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';
import 'package:frontend/controllers/blog_controller.dart';

class BlogController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final LocalStorage storage = new LocalStorage('My App');

  Future<String> createBlog() async {
    try {
      var headers = {'Content-Type': 'application/json'};

      print('por aqui');
      var url = Uri.parse('http://10.0.2.2:5432/api/blogs');
      Map body = {
        'title': titleController.text.trim(),
        'description': descriptionController.text,
        'content': contentController.text
      };
      print('por aqui2');
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      print('por aqui3');
      print(response.body);
      print(body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("correcto");
        if (json['auth'] == true) {
          var token = json['token'];
          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString('token', token);

          titleController.clear();
          descriptionController.clear();
          contentController.clear();
          print("correcto");
          storage.setItem('token', token);
          print("el token es: ");
          print(token);
          Get.off(HomeScreen());
        } else if (json['auth'] == false) {
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

  Future<List<Blog>> getBlogs() async {
    List<Blog> blogs = [];
    final data = await http.get(Uri.parse('http://10.0.2.2:5432/api/blogs'));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      print(data.body);
      Blog blog = Blog(
        //id: u["id"],
        title: u["title"],
        description: u["description"],
        body_text: u["body_text"],
        //author: u["author"],

        //image: u["image"],
        //author: u["author"],
        //date: u["date"]
      );

      blogs.add(blog);
    }
    print(blogs.length);
    return blogs;
  }
  /*Future<List<Object>> getObjects() async {
  List<Object> objects = [];
  final data = await http.get(Uri.parse('http://192.168.1.132:3000/objects/'));
  var jsonData = json.decode(data.body);
  for (var u in jsonData) {
    print(data.body);
    Object object = Object(
        id: u["id"],
        name: u["name"],
        imageUrl: u["imageUrl"],
        price: u["price"].toString(),
        description: u['description'],
        units: u['units']);

    objects.add(object);
  }
  print(objects.length);
  return objects;
}
}*/
}
