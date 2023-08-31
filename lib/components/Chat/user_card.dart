import 'package:flutter/material.dart';
import 'package:war_tracker/models/user.dart';
import 'package:war_tracker/theme_provider.dart';

class UserCard extends StatefulWidget {
  final User user;
  final VoidCallback onTap;

  const UserCard({
    required this.user,
    required this.onTap,
  });

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    // Retrieve the saved theme mode from SharedPreferences
    ThemeMode savedThemeMode = await ThemeHelper.getThemeMode();
    setState(() {
      _themeMode = savedThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _themeMode == ThemeMode.dark ? Colors.grey[700] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.user.imageUrl),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.user.username,
                  style: TextStyle(
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white70
                        : Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
