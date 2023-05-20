import 'dart:convert';

import 'package:frontend/models/user.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:frontend/data/data.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final LocalStorage storage = new LocalStorage('My App');

  Future<void> getUser() async {
    User user;
    String? token = storage.getItem('token');
    print(token);

    print('DECODEEEED AQUI');

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

      print(decodedToken);
      String? userId = decodedToken['id'];
      print(userId);

      print('DECODEEEED AQUI2');

      final data = await http
          .get(Uri.parse('http://10.0.2.2:5432/api/users/profile/' + userId!));
      var jsonData = json.decode(data.body);
      user = User(
        id: userId,
        username: jsonData["username"],
        password: jsonData["password"],
        email: jsonData["email"],
        name: jsonData["name"],
      );
      print(user.id);
      print(user.password);
      print(user.email);
      print(user.username);
      print(user.name);
      print("ahora current");
      currentUser = user;
      print(currentUser.name);
      print(currentUser.email);
      print(currentUser.username);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveUser(String email, String password) async {
    getUser();
    print('saveUser');

    print("userid");
    final User user = User(
      id: currentUser.id,
      username: currentUser.username,
      password: password,
      email: email,
      name: currentUser.name,
    );
    print(user.id);
    currentUser = user;
  }

  Future<User> getOneUser(idUser) async {
    final data =
        await http.get(Uri.parse('http://10.0.2.2:5432/api/users/' + idUser));

    var jsonData = json.decode(data.body);

    User user = User(
      id: jsonData["_id"],
      username: jsonData["username"],
      password: jsonData["password"],
      email: jsonData["email"],
      name: jsonData["name"],
    );

    return user;
  }
}
