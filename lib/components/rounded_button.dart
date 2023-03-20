import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final Function? press;
  final Color? color, textColor;
  final double? width, height, margin;
  const RoundedButton(
      {Key? key,
      this.text,
      this.press,
      this.color,
      this.textColor,
      this.width,
      this.height,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin!),
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: newElevatedButton(),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: Text(
        text!,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
      onPressed: press as void Function()?,
      style: ElevatedButton.styleFrom(
          backgroundColor: this.color,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: height!),
          textStyle: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}
