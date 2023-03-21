//import 'dart:html';

import 'package:flutter/material.dart';
// import 'package:flutter_auth/Screens/Feed/feed_screen.dart';
// import 'package:flutter_auth/Screens/Login/login_screen.dart';
// import 'package:flutter_auth/Screens/Map/ui/pages/home/map_screen.dart';
// import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
// import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:frontend/components/rounded_button.dart';
import 'package:frontend/components/rounded_input_field.dart';
import 'package:frontend/components/input_fields.dart';
import 'package:frontend/components/submit_button.dart';
// import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:frontend/constants.dart';
// import 'package:flutter_auth/data/data.dart';
// import 'package:localstorage/localstorage.dart';
import 'package:frontend/controllers/login_controller.dart';
import 'package:frontend/controllers/registration_controller.dart';
import 'package:get/get.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  RegistrationController registrationController =
      Get.put(RegistrationController());

  LoginController loginController = Get.put(LoginController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 140),
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "INICIAR SESIÓN",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: ButtonBlack),
          ),
          SizedBox(height: size.height * 0.20),
          InputTextFieldWidget(loginController.emailController, 'email address',
              Icons.email, "Correo"),
          SizedBox(height: size.height * 0.07),
          InputTextFieldWidget(loginController.passwordController, 'password',
              Icons.lock, "Contraseña"),
          SizedBox(height: size.height * 0.08),
          SubmitButton(
            onPressed: () async {
              if (loginController.emailController.text.isEmpty) {
                openDialog("Enter your email");
              } else if (loginController.passwordController.text.isEmpty) {
                openDialog("Enter your password");
              } else {
                var result = await loginController.loginWithEmail();
                if (loginController.emailController.text.isNotEmpty &&
                    (result == "The email does not exist")) {
                  openDialog("The email does not exist");
                } else if (loginController.passwordController.text.isNotEmpty &&
                    (result == "Invalid Password")) {
                  openDialog("Invalid Password");
                } else if (result == "The email does not exist") {
                  openDialog("The email does not exist");
                } else if (result == "Invalid Password") {
                  openDialog("Invalid Password");
                }
              }
            },
            title: 'Login',
          )
        ],
      ),
    );
  }

  Future openDialog(String text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color.fromARGB(255, 230, 241, 248),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("WarTracker", style: TextStyle(fontSize: 17)),
          content: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: submit,
            ),
          ],
        ),
      );
  void submit() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: Body(),
    );
  }
}
