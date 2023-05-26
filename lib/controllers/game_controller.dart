import 'dart:convert';

import 'package:frontend/models/meeting.dart';

import 'package:flutter/material.dart';
import 'package:frontend/screens/tournaments.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class GameController extends GetxController {
  TextEditingController playersController = TextEditingController();
  TextEditingController allianceController = TextEditingController();
  TextEditingController victoryPointsInFavourController =
      TextEditingController();
  TextEditingController victoryPointsAgainstController =
      TextEditingController();
  TextEditingController differenceOfVictoryPointsController =
      TextEditingController();
  TextEditingController gamesPlayedController = TextEditingController();

  final LocalStorage storage = new LocalStorage('My App');

  Future<String> createGame(jsonData, id) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      print('Crear game');
      var url = Uri.parse('http://10.0.2.2:5432/api/games/tournament/' + id);
      Map body = jsonData;

      print(body);
      print('todos datos de crear game');
      print(body);

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      print('response de crear game');
      print(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("correcto");
        if (json['status'] == "Game saved") {
          Get.off(TournamentScreen());
        } else if (json['status'] == false) {
          var message = jsonDecode(response.body)['message'];
          return message;
        }
      } else {
        var message2 = jsonDecode(response.body)['message'];
        return message2;
      }
      return "Unknown Error Occured";
    } catch (error) {
      Get.back();
      return "Unknown Error Occured";
    }
  }

  Future<List<dynamic>> getGames() async {
    final data = await http.get(Uri.parse('http://10.0.2.2:5432/api/games'));
    print("data de get games");
    print(data.body);
    var jsonData = json.decode(data.body);
    print("json data de get games");
    print(jsonData);
    return jsonData;
  }

  /*
  Future<List<Map<String, dynamic>>> fetchGames() async {
  final url = Uri.parse('http://your-api-url-here');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Map<String, dynamic>> games = List<Map<String, dynamic>>.from(data);
    return games;
  } else {
    throw Exception('Failed to fetch games');
  }
}*/
  Future<List<Map<String, dynamic>>> fetchGames(meetingid) async {
    print("fetch games1");
    var url =
        Uri.parse('http://10.0.2.2:5432/api/games/tournament/' + meetingid);
    var response = await http.get(url);
    print("fetch games");
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Map<String, dynamic>> games =
          jsonData.cast<Map<String, dynamic>>();
      print("games");
      print(games);
      return games;
    } else {
      throw Exception('Failed to fetch games');
    }
  }

  Future<List<Meeting>> getMeetings() async {
    List<Meeting> meetings = [];
    final data = await http.get(Uri.parse('http://10.0.2.2:5432/api/meetings'));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Meeting meeting = Meeting(
          id: u["_id"],
          title: u["title"],
          description: u["description"],
          organizer: u["organizer"],
          date: u["date"],
          location: u["location"],
          registration_fee: u["registration_fee"],
          participants: u["participants"]);
      meetings.add(meeting);
    }
    return meetings;
  }

  Future<List<dynamic>> getGameByTournament(idTournament) async {
    final data = await http.get(
        Uri.parse('http://10.0.2.2:5432/api/games/tournament/' + idTournament));
    print("data de get games" + data.body);
    print("get game by tournament");
    var jsonData = json.decode(data.body);
    print("json data de get games");
    print(jsonData);
    return jsonData;
  }
}
