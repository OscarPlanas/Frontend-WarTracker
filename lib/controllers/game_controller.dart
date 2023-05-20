import 'dart:convert';

import 'package:frontend/models/meeting.dart';

import 'package:flutter/material.dart';
import 'package:frontend/screens/tournaments.dart';
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

  Future<String> createGame() async {
    try {
      var headers = {'Content-Type': 'application/json'};

      print('Crear game');
      print(playersController);
      print("controller arriba");
      var url = Uri.parse('http://10.0.2.2:5432/api/games');
      Map body = {
        'players': playersController.text.trim(),
        'alliance': allianceController.text,
        'victory_points_in_favour': victoryPointsInFavourController.text,
        'victory_points_against': victoryPointsAgainstController.text,
        'difference_points': differenceOfVictoryPointsController.text,
        'games_played': gamesPlayedController.text,
      };

      print(body['alliance']);
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
          playersController.clear();
          allianceController.clear();
          victoryPointsInFavourController.clear();
          victoryPointsAgainstController.clear();
          differenceOfVictoryPointsController.clear();
          gamesPlayedController.clear();
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
