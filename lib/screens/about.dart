import 'package:flutter/material.dart';
import 'package:war_tracker/sidebar.dart';
import 'package:war_tracker/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  final String themeModeKey = 'theme_mode';

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedThemeMode = prefs.getInt(themeModeKey);
    if (savedThemeMode != null) {
      setState(() {
        _themeMode = ThemeMode.values[savedThemeMode];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title: Text((AppLocalizations.of(context)!.about),
            style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
      ),
      drawer: Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/logoWelcome.png'),
            ),
            SizedBox(height: 16),
            Text(
              'WarTracker',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                  fontSize: 16,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.aboutApp,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
