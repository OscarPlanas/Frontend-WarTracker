import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';

class NumbersWidget extends StatefulWidget {
  final User user;
  final int followersCount;
  final ThemeMode themeMode;

  NumbersWidget(this.user, this.followersCount, this.themeMode);
  @override
  _NumbersWidgetState createState() => _NumbersWidgetState();
}

class _NumbersWidgetState extends State<NumbersWidget> {
  //late ThemeMode themeMode;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //buildButton(text: 'Comments', value: comments),
          buildDivider(),
          buildButton(text: 'Following', value: widget.user.following.length),
          buildDivider(),
          buildButton(text: 'Followers', value: widget.followersCount),
        ],
      );

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(
          color: widget.themeMode == ThemeMode.dark
              ? Colors.white54
              : Colors.black54,
        ),
      );

  Widget buildButton({
    required String text,
    required int value,
  }) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '$value',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: widget.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                  fontSize: 12,
                  color: widget.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
          ],
        ),
      );
}
