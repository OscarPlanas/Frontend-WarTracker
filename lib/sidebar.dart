import 'package:flutter/material.dart';
import 'package:frontend/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:frontend/constants.dart';
import 'package:localstorage/localstorage.dart';

import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/tournaments.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/data/data.dart';

class Sidebar extends StatelessWidget {
  Sidebar({Key? key}) : super(key: key);

  //final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final LocalStorage storage1 = LocalStorage('My App');

  //final userFuture = UserController().getUser();
  //Future<User> user = UserController().getUser();

  @override
  Widget build(BuildContext context) => Drawer(
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
              backgroundImage: AssetImage("assets/images/groguplaceholder.png"),
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
          //runSpacing: 2,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Blog'),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            ListTile(
              title: const Text('Tournaments'),
              leading: const Icon(Icons.sports_esports_outlined),
              onTap: () => Get.offAll(TournamentScreen()),
            ),
            ListTile(
              title: const Text('Leaderboard'),
              leading: const Icon(Icons.leaderboard_outlined),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () => Get.offAll(Profile()),
            ),
            ListTile(
              title: const Text('Chat'),
              leading: const Icon(Icons.chat_outlined),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: () async {
                //final SharedPreferences? prefs = await _prefs;
                //prefs?.clear();
                print("limpiamos localstorage");
                await storage1.clear();
                print(storage1.getItem("token"));
                Get.offAll(WelcomeScreen());
              },
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => Get.offAll(HomeScreen()),
            ),
          ],
        ),
      );
}
