// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class InputTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final String title;
  final bool hiddenText = true;

  InputTextFieldWidget(
      this.textEditingController, this.hintText, this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: TextFormField(
        obscureText: hintText == "password" ? true : false,
        controller: textEditingController,
        validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
        onSaved: (value) => textEditingController.text = value!,
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            ),
            alignLabelWithHint: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            fillColor: Colors.white54,
            hintText: title,
            hintStyle:
                TextStyle(color: ButtonBlack, fontWeight: FontWeight.bold),
            contentPadding: EdgeInsets.only(bottom: 15),
            focusColor: Colors.white60),
      ),
    );
  }
}
