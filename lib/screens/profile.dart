import 'package:flutter/material.dart';
import 'package:frontend/sidebar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/numbers_widget.dart';
import 'package:frontend/sidebar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/data/data.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final double coverHeight = 280;
  final double profileHeight = 144;

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
    );
  }

  Widget buildContent() => Column(
        children: [
          const SizedBox(height: 8),
          Text(
            currentUser.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            currentUser.username,
            style: TextStyle(
              fontSize: 22,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentUser.email,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSocialIcon(FontAwesomeIcons.slack),
              const SizedBox(width: 12),
              buildSocialIcon(FontAwesomeIcons.github),
              const SizedBox(width: 12),
              buildSocialIcon(FontAwesomeIcons.twitter),
              const SizedBox(width: 12),
              buildSocialIcon(FontAwesomeIcons.linkedin),
            ],
          ),
          const SizedBox(height: 8),
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
            'Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. Flutter works with existing code.',
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
        child: Image.network(
          'https://source.unsplash.com/1600x900/?nature',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(
          'https://source.unsplash.com/1600x900/?person',
        ),
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
}
