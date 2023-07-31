import 'package:flutter/material.dart';
import 'package:frontend/sidebar.dart';
import 'package:frontend/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
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

  void _saveThemeMode(int themeModeIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(themeModeKey, themeModeIndex);
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      _saveThemeMode(themeMode.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title: const Text(('Settings'), style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
      ),
      drawer: Sidebar(),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: [
          Card(
            color:
                _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
            child: ListTile(
              leading: Icon(Icons.brightness_6,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              title: Text('Theme Mode',
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              subtitle: Text(
                  _themeMode == ThemeMode.light ? 'Light Mode' : 'Dark Mode',
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: _themeMode == ThemeMode.dark
                          ? Colors.grey[900]
                          : Colors.white,
                      title: Text('Choose Theme Mode',
                          style: TextStyle(
                              color: _themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<ThemeMode>(
                            activeColor: Background,
                            title: Text('Light Mode',
                                style: TextStyle(
                                    color: _themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black)),
                            value: ThemeMode.light,
                            groupValue: _themeMode,
                            onChanged: (value) {
                              changeTheme(value!);
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile<ThemeMode>(
                            activeColor: Background,
                            title: Text('Dark Mode',
                                style: TextStyle(
                                    color: _themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black)),
                            value: ThemeMode.dark,
                            groupValue: _themeMode,
                            onChanged: (value) {
                              changeTheme(value!);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Add more settings options as needed using Card and ListTile
          // For example:
          // Card(
          //   child: ListTile(
          //     leading: Icon(Icons.notifications),
          //     title: Text('Notifications'),
          //     trailing: Switch(
          //       value: _enableNotifications,
          //       onChanged: (value) {
          //         setState(() {
          //           _enableNotifications = value;
          //         });
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
