import 'dart:convert';

import 'package:war_tracker/constants.dart';
import 'package:war_tracker/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';

class RegistrationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final LocalStorage storage = new LocalStorage('My App');
  Future<String> registerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      print('por aqui');
      var url = Uri.parse(localurl + '/api/users/register');

      Map body = {
        'name': nameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'repeatPassword': repeatPasswordController.text,
        'date': dateController.text,
        'imageUrl': "",
        'backgroundImageUrl': "",
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        print("correcto2");

        final json = jsonDecode(response.body);
        print("correcto");
        if (json['auth'] == true) {
          var token = json['token'];
          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString('token', token);

          emailController.clear();
          passwordController.clear();
          nameController.clear();
          usernameController.clear();
          repeatPasswordController.clear();
          dateController.clear();
          print("correcto");
          storage.setItem('token', token);
          Get.off(HomeScreen());

          return "correcto";
        } else if (json['auth'] == false) {
          var message = jsonDecode(response.body)['message'];
          return message;
        }
      } else if (response.statusCode == 402) {
        print("username ya existe");
        return "1";
      } else if (response.statusCode == 403) {
        print("email ya existe");

        return "2";
      } else {
        var message2 = jsonDecode(response.body)['message'];
        return message2;
      }
      return "Unknown Error Occured";
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
      return "Unknown Error Occured";
    }
  }
}
