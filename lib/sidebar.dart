import 'package:flutter/material.dart';
import 'package:frontend/screens/chats.dart';
import 'package:frontend/screens/configuration.dart';
import 'package:frontend/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:frontend/constants.dart';
import 'package:localstorage/localstorage.dart';

import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/tournaments.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/theme_provider.dart';

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
    print(savedThemeMode);
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
            CircleAvatar(
              radius: 52,
              backgroundImage: currentUser.imageUrl != ""
                  ? NetworkImage(currentUser.imageUrl)
                  : AssetImage('assets/images/groguplaceholder.png')
                      as ImageProvider,
            ),
            SizedBox(height: 6),
            Text(currentUser.username,
                style: TextStyle(color: ButtonBlack, fontSize: 22)),
            Text(currentUser.email,
                style: TextStyle(color: ButtonBlack, fontSize: 14)),
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
              title: Text('Home',
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            ListTile(
              title: Text('Tournaments',
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
              title: Text('Leaderboard',
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              leading: Icon(Icons.leaderboard_outlined,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              onTap: () => Get.offAll(HomeScreen()),
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
              title: Text('Profile',
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
              title: Text('Settings',
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              onTap: () => Get.offAll(ConfigurationScreen()),
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              title: Text('Logout',
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
              title: Text('About',
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
              onTap: () => Get.offAll(HomeScreen()),
            ),
          ],
        ),
      );
}
