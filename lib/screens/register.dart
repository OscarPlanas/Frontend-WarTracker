import 'package:flutter/material.dart';

import 'package:frontend/components/input_fields.dart';
import 'package:frontend/components/submit_button.dart';
import 'package:frontend/components/already_have_an_account_acheck.dart';

import 'package:frontend/constants.dart';

import 'package:frontend/controllers/registration_controller.dart';
import 'package:frontend/screens/login.dart';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool emailValid = true;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "REGISTRO",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: ButtonBlack),
          ),
          SizedBox(height: size.height * 0.10),
          InputTextFieldWidget(registrationController.nameController, 'name',
              Icons.person, "Nombre"),
          SizedBox(height: size.height * 0.03),
          InputTextFieldWidget(registrationController.usernameController,
              'username', Icons.person_2_outlined, "Nombre de usuario"),
          SizedBox(height: size.height * 0.03),
          InputTextFieldWidget(registrationController.emailController, 'email',
              Icons.email, "Correo"),
          SizedBox(height: size.height * 0.03),
          InputTextFieldWidget(registrationController.passwordController,
              'password', Icons.lock, "Contraseña"),
          SizedBox(height: size.height * 0.03),
          InputTextFieldWidget(registrationController.repeatPasswordController,
              'password', Icons.lock, "Repetir Contraseña"),
          SizedBox(height: size.height * 0.08),
          SubmitButton(
            onPressed: () async => {
              if (registrationController.nameController.text.isEmpty ||
                  registrationController.usernameController.text.isEmpty ||
                  registrationController.emailController.text.isEmpty ||
                  registrationController.passwordController.text.isEmpty ||
                  registrationController.repeatPasswordController.text.isEmpty)
                {
                  openDialog("Fill all the fields"),
                }
              else if (registrationController.passwordController.text !=
                  registrationController.repeatPasswordController.text)
                {
                  openDialog("Passwords don't match"),
                }
              else if (emailValid !=
                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(
                      registrationController.emailController.text.toString()))
                {
                  openDialog("Email is not valid"),
                }
              else if (registrationController.passwordController.text.length <
                  6)
                {
                  openDialog("Password must be at least 6 characters"),
                }
              else
                {
                  await registrationController.registerWithEmail(),
                }
            },
            title: 'SignUp',
          ),
          SizedBox(height: size.height * 0.02),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
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

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: Body(),
    );
  }
}
