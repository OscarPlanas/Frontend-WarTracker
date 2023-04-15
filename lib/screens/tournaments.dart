import 'package:flutter/material.dart';
import 'package:frontend/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/constants.dart';
import 'package:localstorage/localstorage.dart';
import 'package:frontend/models/tournamentsplaceholder.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/blog.dart';
import 'package:frontend/controllers/blog_controller.dart';
import 'package:frontend/sidebar.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({Key? key}) : super(key: key);

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //Future<List<TournamentsPlace>> tournamentsFuture = BlogController().getBlogs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title:
            const Text(('Tournaments'), style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
      ),
      body: ListView.builder(
        itemCount: tournamentsList.length,
        itemBuilder: (context, index) {
          TournamentsPlace tournaments = tournamentsList[index];
          return Card(
            child: ListTile(
              //tileColor: Colors.lime[100],
              title: Text(tournaments.title),
              subtitle: Text(tournaments.date),
              leading: Image.network(tournaments.image),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.add, color: ButtonBlack),
        backgroundColor: Background,
      ),
    );
  }
}
