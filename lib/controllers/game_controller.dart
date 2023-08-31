import 'dart:convert';

import 'package:war_tracker/constants.dart';
import 'package:war_tracker/models/meeting.dart';

import 'package:flutter/material.dart';
import 'package:war_tracker/screens/tournaments.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

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

      var url = Uri.parse(localurl + '/api/games/tournament/' + id);
      Map body = jsonData;

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

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
    final data = await http.get(Uri.parse(localurl + '/api/games'));
    var jsonData = json.decode(data.body);
    return jsonData;
  }

  Future<List<Map<String, dynamic>>> fetchGames(meetingid) async {
    var url = Uri.parse(localurl + '/api/games/tournament/' + meetingid);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Map<String, dynamic>> games =
          jsonData.cast<Map<String, dynamic>>();
      return games;
    } else {
      throw Exception('Failed to fetch games');
    }
  }

  Future<List<Meeting>> getMeetings() async {
    List<Meeting> meetings = [];
    final data = await http.get(Uri.parse(localurl + '/api/meetings'));
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
          participants: u["participants"],
          imageUrl: u["imageUrl"],
          lat: u["lat"],
          lng: u["lng"]);
      meetings.add(meeting);
    }
    return meetings;
  }

  Future<List<dynamic>> getGameByTournament(idTournament) async {
    final data = await http
        .get(Uri.parse(localurl + '/api/games/tournament/' + idTournament));
    var jsonData = json.decode(data.body);
    return jsonData;
  }
}
