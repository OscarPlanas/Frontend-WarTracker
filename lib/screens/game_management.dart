import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/scrollable_widget.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/game_controller.dart';
import 'package:frontend/sidebar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:json_table/json_table.dart';
import 'package:frontend/screens/tournaments.dart';

class GameManagementPage extends StatefulWidget {
  final String meetingId;
  GameManagementPage(this.meetingId);
  @override
  _GameManagementPageState createState() => _GameManagementPageState();
}

class _GameManagementPageState extends State<GameManagementPage> {
  GameController gameController = Get.put(GameController());

  List<Map<String, dynamic>> jsonSample = [
    {
      'player': '',
      'tournament': '',
      'alliance': '',
      'victory_points_favour': '',
      'victory_points_against': '',
      'difference_points': '',
      'leaders_eliminated': '',
    }
  ];
  var columns = [
    JsonTableColumn("tournament.title", label: "Tournament"),
    JsonTableColumn("player.username", label: "Player"),
    JsonTableColumn("alliance", label: "Alliance"),
    JsonTableColumn("victory_points_favour", label: "Victory points in favour"),
    JsonTableColumn("victory_points_against", label: "Victory points against"),
    JsonTableColumn("difference_points", label: "Points difference"),
    JsonTableColumn("games_played", label: "Games played"),
    JsonTableColumn("leaders_eliminated", label: "Leaders eliminated"),
  ];
  var json2;
  var game2;
  var game3;
  static final String jsonSample2 =
      '[{"player":"","alliance":"","tournament":"","victory_points_favour":"","victory_points_against":"","difference_points":"", "leaders_eliminated":"", "games_played":""}]';
  var json = jsonDecode(jsonSample2);
  var gm;
  bool loading = true;
  Map<String, dynamic> cellValues = {};
  var columns2;
  Future<void> getGameByTournament(idTournament) async {
    setState(() => loading = true);

    final data = await http.get(
        Uri.parse('http://10.0.2.2:5432/api/games/tournament/' + idTournament));
    print("data de get games" + data.body);
    print("get game by tournament");

    game2 = jsonDecode(data.body);
    print(game2);
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getGameByTournament(widget.meetingId));

    print(gm);
    print("a");
    print("print de game2 dentro del initstate");
    print(game2);
    print("print de json2 dentro del initstate");
    cellValues = {};
    // Initialize the columns
    columns2 = [
      JsonTableColumn(
        "tournament.title",
        label: "Tournament",
        valueBuilder: (value) =>
            cellValues['${value.rowIndex}-${value.label}'] ?? value,
      ),
      JsonTableColumn(
        "player.username",
        label: "Player",
        valueBuilder: (value) =>
            cellValues['${value.rowIndex}-${value.label}'] ?? value,
      ),
      JsonTableColumn(
        "alliance",
        label: "Alliance",
        valueBuilder: (value) =>
            cellValues['${value.rowIndex}-${value.label}'] ?? value,
      ),
      JsonTableColumn(
        "victory_points_favour",
        label: "Victory points in favour",
        valueBuilder: (value) =>
            cellValues['${value.rowIndex}-${value.label}'] ?? value,
      ),
      JsonTableColumn(
        "victory_points_against",
        label: "Victory points against",
        valueBuilder: (value) =>
            cellValues['${value.rowIndex}-${value.label}'] ?? value,
      ),
      JsonTableColumn(
        "difference_points",
        label: "Points difference",
        valueBuilder: (value) =>
            cellValues['${value.rowIndex}-${value.label}'] ?? value,
      ),
      JsonTableColumn(
        "games_played",
        label: "Games played",
        valueBuilder: (value) =>
            cellValues['${value.rowIndex}-${value.label}'] ?? value,
      ),
      JsonTableColumn(
        "leaders_eliminated",
        label: "Leaders eliminated",
        valueBuilder: (value) =>
            cellValues['${value.rowIndex}-${value.label}'] ?? value,
      ),
      // Add more columns as needed
    ];
  }

  void updateCellValue(int rowIndex, String columnName, dynamic value) {
    setState(() {
      cellValues['$rowIndex-$columnName'] = value;
    });
  }

  ProgressIndicator get Progress => const CircularProgressIndicator();
  @override
  Widget build(BuildContext context) {
    return loading
        ? Progress
        : Scaffold(
            drawer: Sidebar(),
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(('Game'), style: TextStyle(color: ButtonBlack)),
              iconTheme: IconThemeData(color: ButtonBlack),
              backgroundColor: Background,
            ),
            body: ScrollableWidget(
                child: JsonTable(
              game2.isNotEmpty ? game2 : json,
              columns: columns,
              tableHeaderBuilder: (String? header) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5), color: Colors.blue[300]),
                  child: Text(
                    header!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        color: Colors.white),
                  ),
                );
              },
              tableCellBuilder: (value) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: Colors.green.withOpacity(0.5))),
                  child: EditableText(
                    controller: TextEditingController()..text = value,
                    onChanged: (text) => {},
                    enableInteractiveSelection: true,
                    maxLines: 1,
                    selectionControls: cupertinoTextSelectionControls,
                    selectionColor: Colors.blue,
                    backgroundCursorColor: Colors.pink,
                    cursorColor: Colors.blue,
                    focusNode: FocusNode(),
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
            )),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async => {
                    setState(
                      () {
                        game2.add({
                          '_id': '',
                          'alliance': '',
                          'tournament': '',
                          'player': '',
                          'victory_points_favour': '',
                          'victory_points_against': '',
                          'difference_points': '',
                          'games_played': '',
                          'leaders_eliminated': '',
                          '_v': '',
                        });
                      },
                    )
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    gameController.createGame(game2, game2['tournament']);
                  },
                  child: Icon(Icons.save),
                ),
              ],
            ),
          );
  }
}
