import 'package:flutter/material.dart';
import 'package:war_tracker/constants.dart';
import 'package:war_tracker/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParticipantsScreen extends StatefulWidget {
  final List<dynamic> listParticipants;

  ParticipantsScreen({required this.listParticipants});

  @override
  _ParticipantsScreenState createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    // Retrieve the saved theme mode from SharedPreferences
    ThemeMode savedThemeMode = await ThemeHelper.getThemeMode();
    print(savedThemeMode);
    setState(() {
      _themeMode = savedThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(color: ButtonBlack),
        backgroundColor: Background,
        title: Text(AppLocalizations.of(context)!.participantsUsernames,
            style: TextStyle(color: ButtonBlack)),
      ),
      body: Column(
        children: widget.listParticipants.map((participant) {
          return ListTile(
            title: Text(participant['username'],
                style: _themeMode == ThemeMode.dark
                    ? TextStyle(color: Colors.white)
                    : TextStyle(
                        color: Colors
                            .black)), // Replace 'username' with the actual key in your user data
          );
        }).toList(),
      ),
    );
  }
}
