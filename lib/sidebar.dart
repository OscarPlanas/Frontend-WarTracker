import 'package:flutter/material.dart';
import 'package:war_tracker/screens/chats.dart';
import 'package:war_tracker/screens/configuration.dart';
import 'package:war_tracker/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:war_tracker/constants.dart';
import 'package:localstorage/localstorage.dart';

import 'package:war_tracker/screens/home.dart';
import 'package:war_tracker/screens/tournaments.dart';
import 'package:war_tracker/screens/profile.dart';
import 'package:war_tracker/data/data.dart';
import 'package:war_tracker/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:war_tracker/screens/about.dart';
import 'package:war_tracker/screens/calendar.dart';

class Sidebar extends StatefulWidget {
  Sidebar({Key? key}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  ThemeMode _themeMode = ThemeMode.system; // Initialize with system mode
  final LocalStorage storage1 = LocalStorage('My App');

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
  Widget build(BuildContext context) => Drawer(
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),
        ],
      )));

  Widget buildHeader(BuildContext context) => Container(
        color: Background,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.offAll(Profile(currentUser));
              },
              child: CircleAvatar(
                radius: 52,
                backgroundImage: currentUser.imageUrl != ""
                    ? NetworkImage(currentUser.imageUrl)
                    : AssetImage('assets/images/groguplaceholder.png')
                        as ImageProvider,
              ),
            ),
            SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                Get.offAll(Profile(currentUser));
              },
              child: Text(currentUser.username,
                  style: TextStyle(color: ButtonBlack, fontSize: 22)),
            ),
            GestureDetector(
              onTap: () {
                Get.offAll(Profile(currentUser));
              },
              child: Text(currentUser.email,
                  style: TextStyle(color: ButtonBlack, fontSize: 14)),
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.home_outlined,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              title: Text(AppLocalizations.of(context)!.sidebarHome,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.sidebarTournaments,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              leading: Icon(Icons.sports_esports_outlined,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              onTap: () => Get.offAll(TournamentScreen()),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.sidebarCalendar,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              leading: Icon(Icons.calendar_month_outlined,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              onTap: () => Get.offAll(Calendar()),
            ),
            Divider(
                color: _themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black54),
            ListTile(
              leading: Icon(Icons.person_outline,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              title: Text(AppLocalizations.of(context)!.profile,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              onTap: () => Get.offAll(Profile(currentUser)),
            ),
            ListTile(
                title: Text('Chat',
                    style: TextStyle(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black)),
                leading: Icon(Icons.chat_outlined,
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
                onTap: () {
                  Get.offAll(ChatsScreen());
                }),
            ListTile(
              leading: Icon(Icons.settings_outlined,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              title: Text(AppLocalizations.of(context)!.sidebarSettings,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              onTap: () => Get.to(ConfigurationScreen()),
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              title: Text(AppLocalizations.of(context)!.sidebarLogout,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              onTap: () async {
                print("limpiamos localstorage");
                await storage1.clear();
                print(storage1.getItem("token"));
                Get.offAll(WelcomeScreen());
              },
            ),
            Divider(
                color: _themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black54),
            ListTile(
              leading: Icon(Icons.info_outline,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              title: Text(AppLocalizations.of(context)!.about,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              onTap: () => Get.to(AboutScreen()),
            ),
          ],
        ),
      );
}
