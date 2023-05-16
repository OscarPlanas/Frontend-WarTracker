import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/usersplaceholder.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/components/scrollable_widget.dart';
import 'package:frontend/components/text_dialog_widget.dart';
import 'package:frontend/sidebar.dart';
import 'package:frontend/constants.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:json_table/json_table.dart';
import 'dart:convert';

class GameManagementPage extends StatefulWidget {
  @override
  _GameManagementPageState createState() => _GameManagementPageState();
}

class _GameManagementPageState extends State<GameManagementPage> {
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GameController gameController = Get.put(GameController());
  //late List<dynamic> game;
/*static final String jsonSample = ‘[‘ +
‘{“Date”:”24-Apr”, “Excercise”: “Done”, “Homework”: “Not done”},’ +
‘{“Date”:”25-Apr”, “Excercise”: “Not Done”, “Homework”: “Not done”}’ +
‘]’;*/

  List<Map<String, dynamic>> jsonSample = [
    {
      'players': 'a',
      'alliance': 'b',
      'victory points in favour': 'c',
      'victory points against': 'd',
      'difference of victory points': 'e',
      'games played': 'f'
    }
  ];
  var json2;
  var game2;
  var game3;
  static final String jsonSample2 =
      '[{"players":"a","alliance":"b","victory points in favour":"c","victory points against":"d","difference of victory points":"e","games played":"f"}, {"players":"a","alliance":"b","victory points in favour":"c","victory points against":"d","difference of victory points":"e","games played":"f"}]';
  var json = jsonDecode(jsonSample2);
  var gm;
  bool loading = true;
  Future<void> getGames() async {
    //List<dynamic> games = [];
    setState(() => loading = true);
    var placeholder;
    final data = await http.get(Uri.parse('http://10.0.2.2:5432/api/games'));
    print("data de get games");
    print(data.body);
    //var jsonData = json.decode(data.body);
    print("json data de get games");
    //print(jsonData);
    placeholder = data.body;
    print(placeholder);
    game2 = jsonDecode(placeholder);
    //game2 = jsonEncode(data.body);
    print("aaaaaaaaaaaaaaaaa");
    print(game2);
    setState(() => loading = false);
  }

  /*bool loading = true;
  Future<void> readJson() async {
    setState(() => loading = true);
    response = await rootBundle.loadString('assets/cfg/onboarding_tasks.json');
    final onboardingTodo = onboardingTodoFromJson(response);
    onboardingTasks.addAll(onboardingTodo.values);
    print("onboarding length - " + onboardingTasks.length.toString());
    setState(() => loading = false);
  }*/
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getGames());

    getGames();
    //gm = jsonDecode(game2);
    print(gm);
    print("a");
    //json2 = jsonDecode(game);
    print("print de game2 dentro del initstate");
    print(game2);
    print("print de json2 dentro del initstate");
    //print(json2);
  }

  ProgressIndicator get Progress => const CircularProgressIndicator();
  @override
  Widget build(BuildContext context) {
    return loading
        ? Progress
        : Scaffold(
            drawer: Sidebar(),
            appBar: AppBar(
              iconTheme: IconThemeData(color: ButtonBlack),
              title: const Text(('Game'), style: TextStyle(color: ButtonBlack)),
              backgroundColor: Background,
            ),
            body: ScrollableWidget(
                child: JsonTable(
              game2,
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
                    gameController.getGames();
                  },
                  child: Icon(Icons.save),
                ),
              ],
            ),
          );
  }
}
