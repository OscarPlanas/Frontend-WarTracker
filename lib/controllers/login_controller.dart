import 'dart:convert';

import 'package:frontend/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final LocalStorage storage = new LocalStorage('My App');

  Future<String> loginWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};

      print('por aqui');
      var url = Uri.parse('http://10.0.2.2:5432/api/auth/login');
      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text
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

          emailController.clear();
          passwordController.clear();
          print("correcto");
          storage.setItem('token', token);
          print("el token es: ");
          print(token);
          print("Haciendo storage get item");
          print(storage.getItem("token"));
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
