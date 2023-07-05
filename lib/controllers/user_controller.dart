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

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  final LocalStorage storage = new LocalStorage('My App');

  Future<void> getUser() async {
    //User user;
    String? token = storage.getItem('token');

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

      String? userId = decodedToken['id'];

      final data = await http
          .get(Uri.parse('http://10.0.2.2:5432/api/users/' + userId!));
      var jsonData = json.decode(data.body);

      User user = User(
        id: userId,
        username: jsonData["username"],
        password: jsonData["password"],
        email: jsonData["email"],
        name: jsonData["name"],
        imageUrl: jsonData["imageUrl"],
        backgroundImageUrl: jsonData["backgroundImageUrl"],
        about: jsonData["about"],
      );

      currentUser = user;
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveUser(String email, String password) async {
    await getUser();

    final User user = User(
        id: currentUser.id,
        username: currentUser.username,
        password: password,
        email: email,
        name: currentUser.name,
        imageUrl: currentUser.imageUrl,
        backgroundImageUrl: currentUser.backgroundImageUrl,
        about: currentUser.about);

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
      imageUrl: jsonData["imageUrl"],
      backgroundImageUrl: jsonData["backgroundImageUrl"],
      about: jsonData["about"],
    );

    return user;
  }

  Future<int> editUser(
    idUser,
    currentPhoto,
    currentBackgroundPhoto,
    currentPassword,
    newPassword,
    isPasswordChanged,
  ) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('http://10.0.2.2:5432/api/users/edit/' + idUser);

      Map<String, dynamic> body = {
        'name': nameController.text.trim(),
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'imageUrl': currentPhoto,
        'backgroundImageUrl': currentBackgroundPhoto,
        'password': currentPassword,
        'about': aboutController.text.trim(),
      };

      if (isPasswordChanged) {
        body['repeatPassword'] = newPassword;
      }

      if (usernameController.text.trim() != currentUser.username) {
        http.Response response = await http.put(
          url,
          body: jsonEncode(body),
          headers: headers,
        );

        if (response.statusCode == 200) {
          print("correcto");
          return 0;
        } else if (response.statusCode == 401) {
          print("password incorrecto");
          return 1;
        } else if (response.statusCode == 402) {
          print("username exists");

          return 2;
        } else {
          print("incorrecto");
          return 3;
        }
      }

      http.Response response = await http.put(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 402) {
        print("correcto");
        return 0;
      } else if (response.statusCode == 401) {
        print("password incorrecto");
        return 1;
      } else {
        print("incorrecto");
        return 3;
      }
    } catch (e) {
      print(e);
      return 3;
    }
  }
}
