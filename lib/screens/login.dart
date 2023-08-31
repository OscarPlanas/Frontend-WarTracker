import 'package:flutter/material.dart';

import 'package:war_tracker/components/input_fields.dart';
import 'package:war_tracker/components/submit_button.dart';
import 'package:war_tracker/constants.dart';
import 'package:war_tracker/components/already_have_an_account_acheck.dart';

import 'package:war_tracker/controllers/login_controller.dart';
import 'package:war_tracker/controllers/registration_controller.dart';
import 'package:war_tracker/screens/register.dart';
import 'package:get/get.dart';
import 'package:war_tracker/controllers/user_controller.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? token = "";
  RegistrationController registrationController =
      Get.put(RegistrationController());

  LoginController loginController = Get.put(LoginController());
  UserController userController = Get.put(UserController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 100),
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
                await userController.saveUser(
                    loginController.emailController.text,
                    loginController.passwordController.text);
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
          ),
          SizedBox(height: size.height * 0.02),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return RegisterScreen();
                  },
                ),
              );
            },
          ),
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
          title: Text("war_tracker", style: TextStyle(fontSize: 17)),
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
