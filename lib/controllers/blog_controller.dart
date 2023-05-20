import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:frontend/models/blog.dart';

import 'package:frontend/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:frontend/data/data.dart';

class BlogController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final LocalStorage storage = new LocalStorage('My App');

  Future<String> createBlog() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      print(titleController.text);
      print("controller arriba");

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

  Future<List<Blog>> getBlogs() async {
    List<Blog> blogs = [];
    final data = await http.get(Uri.parse('http://10.0.2.2:5432/api/blogs'));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      //print(data.body);
      Blog blog = Blog(
          //id: u["id"],
          title: u["title"],
          description: u["description"],
          body_text: u["body_text"],
          author: u["author"],
          //image: u["image"],

          date: u["date"]);
      //var owner = json.decode(blog.author.toString());
      print("VEmOS AUTHOR " + blog.author['username']);
      print("VEMOS DATE" + blog.date);
      blogs.add(blog);
    }
    //print(blogs.length);
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
