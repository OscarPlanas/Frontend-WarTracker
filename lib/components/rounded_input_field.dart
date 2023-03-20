import 'package:flutter/material.dart';
import 'package:frontend/components/text_field_container.dart';
import 'package:frontend/constants.dart';

class RoundedInputField extends StatefulWidget {
  final String? hintText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    TextStyle? hintStyle,
    Color? fillColor,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      fillColor: Background,
      borderColor: Color(0xfff0e1f8),
      child: TextField(
        style: TextStyle(
            color: ButtonBlack, fontSize: 16, fontWeight: FontWeight.bold),
        controller: _controller,
        onChanged: widget.onChanged,
        cursorColor: DetailsColor,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: ButtonBlack,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: 16, color: ButtonBlack, fontWeight: FontWeight.bold),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
