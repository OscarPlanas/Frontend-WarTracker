import 'dart:convert';

import 'package:frontend/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  //TextEditingController dateController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      print('por aqui');
      var url = Uri.parse('http://10.0.2.2:5432/api/users/register');

      Map body = {
        'name': nameController.text,
        'username': usernameController.text,
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'repeatPassword': repeatPasswordController.text,
      };
      if (passwordController.text != repeatPasswordController.text) {
        print("error");
        showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: new Text("Las contraseñas no coinciden."),
                actions: <Widget>[
                  new TextButton(
                    child: new Text("Cerrar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
      /*if (passwordController.text.length < 6) {
        throw "La contraseña debe tener al menos 6 caracteres";
      }
      if (nameController.text == '' ||
          usernameController.text == '' ||
          emailController.text == '' ||
          passwordController.text.isEmpty) {
        AlertDialog(
          title: Text('Error'),
          content: Text('No puede haber campos vacíos'),
        );
        throw "El nombre no puede estar vacío";
      }*/
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
          print("correcto");
          Get.off(HomeScreen());
        } else if (json['auth'] == false) {
          throw jsonDecode(response.body)['message'];
        }
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
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
    }
  }
}
