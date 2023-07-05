import 'package:flutter/material.dart';
import 'package:frontend/screens/edit_profile.dart';
import 'package:frontend/sidebar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/numbers_widget.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/data/data.dart';
import 'package:get/get.dart';
import 'package:frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  final User user;

  Profile(this.user);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  bool isUser = false;

  @override
  void initState() {
    super.initState();
    checkIsUser();
  }

  Future<void> checkIsUser() async {
    var url = Uri.parse('http://10.0.2.2:5432/api/users/' + widget.user.id);
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      currentUser.username == data['username'] ? isUser = true : isUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: ButtonBlack)),
        iconTheme: IconThemeData(color: ButtonBlack),
        backgroundColor: Background,
      ),
      drawer: Sidebar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isUser)
            FloatingActionButton(
              child: Icon(Icons.edit, color: ButtonBlack),
              backgroundColor: Background,
              onPressed: () async {
                final updatedUser = await Get.to(EditProfile(widget.user));

                if (updatedUser != null) {
                  setState(() {
                    // Update the user object with the new data
                    widget.user.name = updatedUser.name;
                    widget.user.username = updatedUser.username;
                    widget.user.email = updatedUser.email;
                    widget.user.imageUrl = updatedUser.imageUrl;
                    widget.user.backgroundImageUrl =
                        updatedUser.backgroundImageUrl;
                  });
                }
              },
            ),
        ],
      ),
    );
  }

  Widget buildContent() => Column(
        children: [
          const SizedBox(height: 8),
          Text(
            widget.user.username,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.user.name,
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.user.email,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 16),
          Divider(),
          const SizedBox(height: 16),
          NumbersWidget(),
          Divider(),
          const SizedBox(height: 16),
          buildAbout(),
          const SizedBox(height: 32),
        ],
      );

  Widget buildAbout() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.user.about,
            style: TextStyle(
              fontSize: 18,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.network(widget.user.backgroundImageUrl, fit: BoxFit.cover),
        width: double.infinity,
        height: coverHeight,
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(widget.user.imageUrl),
      );

  Widget buildSocialIcon(IconData icon) => CircleAvatar(
        radius: 25,
        child: Material(
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Center(
              child: Icon(
                icon,
                size: 32,
              ),
            ),
          ),
        ),
      );

  Future openDialog(String text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color.fromARGB(255, 230, 241, 248),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("WarTracker", style: TextStyle(fontSize: 17)),
          content: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: submit,
            ),
          ],
        ),
      );
  void submit() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
