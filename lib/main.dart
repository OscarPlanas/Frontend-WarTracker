import 'package:war_tracker/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:war_tracker/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale?>(
      future: _loadSavedLocale(), // Create this method to load the saved locale
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Auth',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            supportedLocales: L10n.all,
            locale: snapshot.data, // Set the previously saved locale here
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            home: WelcomeScreen(),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<Locale?> _loadSavedLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return null;
  }
}
