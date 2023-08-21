import 'package:flutter/material.dart';
import 'package:frontend/sidebar.dart';
import 'package:frontend/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _selectedLocale = Locale('en');

  final String themeModeKey = 'theme_mode';

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _loadLanguage();
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

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguageCode = prefs.getString('language_code');
    if (savedLanguageCode != null) {
      setState(() {
        _selectedLocale = Locale(savedLanguageCode);
      });
    }
    print("load: " + savedLanguageCode.toString());
  }

  void _saveLanguage(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', locale.languageCode);
  }

  void _updateLocale(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
    _saveLanguage(locale);
    Get.updateLocale(locale); // Update the locale using GetX

    // Show a snackbar to notify the user to restart the app
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title: Text((AppLocalizations.of(context)!.sidebarSettings),
            style: TextStyle(color: ButtonBlack)),
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
              title: Text(AppLocalizations.of(context)!.theme,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              subtitle: Text(
                  _themeMode == ThemeMode.light
                      ? AppLocalizations.of(context)!.lightTheme
                      : AppLocalizations.of(context)!.darkTheme,
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
                      title: Text(AppLocalizations.of(context)!.choseMode,
                          style: TextStyle(
                              color: _themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<ThemeMode>(
                            activeColor: Background,
                            title: Text(
                                AppLocalizations.of(context)!.lightTheme,
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
                            title: Text(AppLocalizations.of(context)!.darkTheme,
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
          Card(
            color:
                _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
            child: ListTile(
              leading: Icon(Icons.language,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              title: Text(AppLocalizations.of(context)!.languageTitle,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              subtitle: Text(AppLocalizations.of(context)!.language,
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
                      title: Text(AppLocalizations.of(context)!.chooseLanguage,
                          style: TextStyle(
                              color: _themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<Locale>(
                            activeColor: Background,
                            title: Text(AppLocalizations.of(context)!.english,
                                style: TextStyle(
                                    color: _themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black)),
                            value: const Locale('en'),
                            groupValue: _selectedLocale,
                            onChanged: (value) {
                              _saveLanguage(value!);
                              _updateLocale(value);
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)!.appRestarted,
                                toastLength: Toast.LENGTH_LONG,
                              );
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile<Locale>(
                            activeColor: Background,
                            title: Text(AppLocalizations.of(context)!.spanish,
                                style: TextStyle(
                                    color: _themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black)),
                            value: const Locale('es'),
                            groupValue: _selectedLocale,
                            onChanged: (value) {
                              _saveLanguage(value!);
                              _updateLocale(value);
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context)!.appRestarted,
                                toastLength: Toast.LENGTH_LONG,
                              );
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
        ],
      ),
    );
  }
}
