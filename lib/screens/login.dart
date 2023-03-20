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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String email;
    String password;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 140),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "INICIAR SESIÓN",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: ButtonBlack),
          ),
          SizedBox(height: size.height * 0.20),
          // RoundedInputField(
          //   hintText: "Correo",
          //   onChanged: (value) {
          //     email = value;
          //   },
          // ),

          InputTextFieldWidget(loginController.emailController, 'email address',
              Icons.email, "Correo"),
          SizedBox(height: size.height * 0.07),
          InputTextFieldWidget(loginController.passwordController, 'password',
              Icons.lock, "Contraseña"),

          // TextField(
          //     obscureText: true,
          //     decoration: InputDecoration(
          //       hintText: "AAAAA",
          //       filled: false,
          //     )),
          // SizedBox(height: size.height * 0.15),
          // RoundedPasswordField(
          //   onChanged: (value) {
          //     password = value;
          //   },
          // ),
          // SizedBox(height: size.height * 0.03),
          // RoundedButton(
          //   margin: 10,
          //   text: "INICIAR SESIÓN",
          //   color: ButtonBlack,
          //   textColor: Background,
          //   width: size.width * 0.8,
          //   height: 20.0,
          //   press: () async {
          // await saveUser('$email', '$password');
          // await getUserByEmail();
          // await login('$email', '$password');
          // return Future.delayed(
          // const Duration(seconds: 1),
          // () => Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           if (currentUser.email == null ||
          //               currentUser.email == "") {
          //             return LoginScreen();
          //           } else if (storage.getItem('token') != null) {
          //             checkLike(currentUser.id);
          //             return MapScreen();
          //           } else {
          //             return LoginScreen();
          //           }
          //           //return MapScreen();
          //         },
          //       ),
          //     ));
          //     loginController.loginWithEmail();
          //   },
          // ),
          SizedBox(height: size.height * 0.08),
          SubmitButton(
            onPressed: () => loginController.loginWithEmail(),
            title: 'Login',
          )
          //   AlreadyHaveAnAccountCheck(
          //     press: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) {
          //             return SignUpScreen();
          //           },
          //         ),
          //       );
          //     },
          //   ),
        ],
      ),
    );
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
