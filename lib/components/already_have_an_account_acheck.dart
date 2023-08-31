import 'package:flutter/material.dart';
import 'package:war_tracker/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    this.press,
    Color? textColor,
    Color? color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Aún no tienes cuenta? " : "Tienes una cuenta? ",
          style: TextStyle(color: ButtonBlack),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Registrate" : "Inicia Sesión",
            style: TextStyle(
              color: ButtonBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
