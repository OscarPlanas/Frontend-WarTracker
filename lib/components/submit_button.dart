import 'package:flutter/material.dart';
import 'package:war_tracker/constants.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const SubmitButton(
      {Key? formKey, required this.onPressed, required this.title})
      : super(key: formKey);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 50,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
            color: Colors.white.withOpacity(0.25),
            offset: Offset(0, 0),
            blurRadius: 2,
            spreadRadius: 1)
      ]),
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none)),
              backgroundColor: MaterialStateProperty.all<Color>(
                ButtonBlack,
              )),
          onPressed: onPressed,
          child: Text(title,
              style: TextStyle(
                fontSize: 24,
                color: Background,
                fontWeight: FontWeight.w500,
              ))),
    );
  }
}
