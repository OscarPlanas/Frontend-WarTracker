import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/register.dart';

//import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:frontend/components/rounded_button.dart';
import 'package:frontend/constants.dart';
//import 'package:frontend/main.dart';
import 'package:localstorage/localstorage.dart';
import 'package:frontend/screens/home.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';

class Body extends StatelessWidget {
  //final LocalStorage storage1 = LocalStorage('My App');
  //String? token = "";

  @override
  Widget build(BuildContext context) {
    //final LocalStorage storage = new LocalStorage('My App');
    //print("es este print de aqui al principio");
    //print(storage.getItem('token'));
    //print("si");
    //checkLogin();
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

  /*void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = storage1.getItem("token");
    if (val != null) {
      Get.off(HomeScreen());
    }
    print("pasa por este login");
  }*/
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
    //getCred();
    checkLogin();
  }

  /*void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(storage1.getItem('My App'));
    print("pasamos al token");
    setState(() {
      token = storage1.getItem("token");
    });
    print(token);
    print("fffff");
  }*/

  void checkLogin() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
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
