import 'dart:convert';

import 'package:frontend/models/user.dart';

import 'package:frontend/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';
import 'package:frontend/controllers/blog_controller.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:frontend/data/data.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final LocalStorage storage = new LocalStorage('My App');
//Future<List<Blog>> getBlogs() async {
  Future<void> getUser() async {
    User user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    /* var decoded1 = JWT.decode(token!);
    print(decoded1);
    var decoded = JWT.verify(token, SecretKey('NuestraClaveEA3'));*/

    print('DECODEEEED AQUI');

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    print(decodedToken);
    String? userId = decodedToken['id'];
    print(userId);

    /*print(currentUser.name);
    print(currentUser.email);
    print('separacion');
    print(currentUser.username);
    print(currentUser.password);
    print(decoded);*/

    //var json = jsonDecode(decoded.payload);
    print('DECODEEEED AQUI2');
    //print(json);
    //var userId = decoded.;
    //console.log(userId)

    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/users/profile/' + userId!));
    var jsonData = json.decode(data.body);
    user = User(
      //id: jsonData["id"],
      username: jsonData["username"],
      password: jsonData["password"],
      email: jsonData["email"],
      name: jsonData["name"],

      //imageUrl: jsonData["imageUrl"],
      //tasks: jsonData["tasks"],
    );
    print(user.password);
    print(user.email);
    print(user.username);
    print(user.name);
    print("ahora current");
    currentUser = user;
    print(currentUser.name);
    print(currentUser.email);
    print(currentUser.username);
    //return user;
  }

  Future<void> saveUser(String email, String password) async {
    final User user = User(
      //id: currentUser.id,
      username: currentUser.username,
      password: password,
      email: email,
      name: currentUser.name,
    );

    currentUser = user;
  }
// export const getUser = async (id: string) => {
//     return await axios.get(`${API}profile/${id}`);
// }
  /*Future<List<Blog>> getBlogs() async {
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
  }*/
}
