import 'package:flutter/material.dart';
import 'package:war_tracker/screens/login.dart';
import 'package:war_tracker/screens/register.dart';

import 'package:war_tracker/components/rounded_button.dart';
import 'package:war_tracker/constants.dart';
import 'package:localstorage/localstorage.dart';
import 'package:war_tracker/screens/home.dart';
import 'package:get/get.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/logoWelcome.png",
          ),
          SizedBox(height: size.height * 0.15),
          RoundedButton(
            margin: 10,
            text: "INICIAR SESIÓN",
            color: ButtonBlack,
            textColor: Background,
            width: size.width * 0.8,
            height: 20.0,
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
          SizedBox(height: size.height * 0.05),
          RoundedButton(
            margin: 10,
            text: "REGISTRAR",
            color: ButtonBlack,
            textColor: Background,
            width: size.width * 0.8,
            height: 20.0,
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
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? token = "";
  final LocalStorage storage1 = LocalStorage('My App');

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    await storage1.ready;
    final val1 = await storage1.getItem('token');
    print("print de val1");
    print(val1);
    String? val = storage1.getItem("token");

    if (val != null) {
      Get.off(HomeScreen());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: Body(),
    );
  }
}
