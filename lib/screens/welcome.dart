import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/register.dart';

//import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:frontend/components/rounded_button.dart';
import 'package:frontend/constants.dart';
//import 'package:frontend/main.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: Body(),
    );
  }
}
