import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/game_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  final String meetingId;
  GameScreen(this.meetingId);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<DataRow> dataRows = []; // List to hold the data rows
  GameController gameController = Get.put(GameController());

  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _nextId = 1;
  bool isOwner = false;

  List<List<TextEditingController>> controllersList = [];

  Future<List<Map<String, dynamic>>> fetchGames(String meetingId) async {
    var url =
        Uri.parse('http://10.0.2.2:5432/api/games/tournament/' + meetingId);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> games =
          List<Map<String, dynamic>>.from(data);
      return games;
    } else {
      throw Exception('Failed to fetch games');
    }
  }

  void _updateTableData() async {
    try {
      List<Map<String, dynamic>> games = await fetchGames(widget.meetingId);

      List<DataRow> newRows = [];
      for (var game in games) {
        game['id'] = _nextId++;
        DataRow newRow = DataRow(
          cells: [
            DataCell(TextField(
              controller:
                  TextEditingController(text: game['player']['username']),
              onChanged: (newValue) {
                // Update the value in the data source when the text field changes
                game['player']['username'] = newValue;
              },
            )),
            DataCell(TextField(
              controller: TextEditingController(text: game['alliance']),
              onChanged: (newValue) {
                game['alliance'] = newValue;
              },
            )),
            DataCell(TextField(
              controller: TextEditingController(
                  text: game['victory_points_favour'].toString()),
              onChanged: (newValue) {
                try {
                  game['victory_points_favour'] = int.parse(newValue);
                } catch (e) {
                  print('Invalid input for points favour: $newValue');
                }
              },
            )),
            DataCell(TextField(
              controller: TextEditingController(
                  text: game['victory_points_against'].toString()),
              onChanged: (newValue) {
                try {
                  game['victory_points_against'] = int.parse(newValue);
                } catch (e) {
                  print('Invalid input for points against: $newValue');
                }
              },
            )),
            DataCell(TextField(
              controller: TextEditingController(
                  text: game['difference_points'].toString()),
              onChanged: (newValue) {
                try {
                  game['difference_points'] = int.parse(newValue);
                } catch (e) {
                  print('Invalid input for points difference: $newValue');
                }
              },
            )),
            DataCell(TextField(
              controller:
                  TextEditingController(text: game['games_played'].toString()),
              onChanged: (newValue) {
                try {
                  game['games_played'] = int.parse(newValue);
                } catch (e) {
                  print('Invalid input for games played: $newValue');
                }
              },
            )),
            DataCell(TextField(
              controller: TextEditingController(
                  text: game['leaders_eliminated'].toString()),
              onChanged: (newValue) {
                try {
                  game['leaders_eliminated'] = int.parse(newValue);
                } catch (e) {
                  print('Invalid input for leaders eliminated: $newValue');
                }
              },
            )),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete the row when the delete button is pressed
                _deleteRow(game);
              },
            )),
          ],
        );
        newRows.add(newRow);
      }

      setState(() {
        dataRows = newRows;
      });
    } catch (e) {
      print('Error fetching games: $e');
    }
  }

  void _deleteRow(Map<String, dynamic> game) async {
    var gameId = game['_id'];
    if (isOwner) {
      var url = Uri.parse('http://10.0.2.2:5432/api/games/row/$gameId');
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        // Row deleted successfully, update the table data
        _updateTableData();
      } else {
        print('Failed to delete row: ${response.body}');
      }
      print("delete");
    } else {
      openDialog("You can't delete this row, you are not the owner");
    }
  }

  void updateRowData(int rowIndex, String newValue) {
    setState(() {
      // Create a new list to store the updated rows
      List<DataRow> updatedRows = [];
      for (int i = 0; i < dataRows.length; i++) {
        if (i == rowIndex) {
          // Update the specific row with the new value
          updatedRows.add(DataRow(cells: [
            DataCell(Text('Row ${i + 1}')),
            DataCell(Text(newValue)),
          ]));
        } else {
          // Keep the other rows unchanged
          updatedRows.add(dataRows[i]);
        }
      }
      // Update the rows list with the updated rows
      dataRows = updatedRows;
    });
  }

  void _sortColumn(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      dataRows.sort((a, b) {
        final valueA = _extractValue(a.cells[columnIndex].child);
        final valueB = _extractValue(b.cells[columnIndex].child);

        if (valueA is num && valueB is num) {
          return ascending
              ? valueA.compareTo(valueB)
              : valueB.compareTo(valueA);
        } else if (valueA is String && valueB is String) {
          return ascending
              ? valueA.compareTo(valueB)
              : valueB.compareTo(valueA);
        } else {
          // Handle null values
          if (valueA == null && valueB == null) {
            return 0; // Both values are null, consider them equal
          } else if (valueA == null) {
            return ascending ? -1 : 1; // Null value is considered lower
          } else if (valueB == null) {
            return ascending ? 1 : -1; // Null value is considered lower
          }

          // Handle other types or incompatible types

          return 0; // Do not change the order if types are different
        }
      });
    });
  }

  dynamic _extractValue(Widget child) {
    if (child is Text) {
      final textValue = child.data;
      final parsedInt = int.tryParse(textValue ?? '');
      return parsedInt != null ? parsedInt : textValue;
    } else if (child is TextField) {
      final textValue = child.controller!.text;
      final parsedInt = int.tryParse(textValue);
      return parsedInt != null ? parsedInt : textValue;
    } else if (child is RichText) {
      final textValue = child.text.toPlainText();
      final parsedInt = int.tryParse(textValue);
      return parsedInt != null ? parsedInt : textValue;
    }
    return null;
  }

  Future<void> checkIsOwner() async {
    var url =
        Uri.parse('http://10.0.2.2:5432/api/meetings/' + widget.meetingId);
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    currentUser.username == data['organizer']['username']
        ? isOwner = true
        : isOwner = false;
  }

  @override
  void initState() {
    super.initState();
    _updateTableData();
    checkIsOwner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.of(context)!.gameTable,
            style: TextStyle(color: ButtonBlack)),
        iconTheme: IconThemeData(color: ButtonBlack),
        backgroundColor: Background,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            columns: [
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  constraints: BoxConstraints(minHeight: 48),
                  child: SizedBox(
                    width: 100,
                    child: InkWell(
                      onTap: () {
                        _sortColumn(0, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.player,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_sortColumnIndex == 0)
                            Icon(
                              _sortAscending
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  constraints: BoxConstraints(minHeight: 48),
                  child: SizedBox(
                    width: 100,
                    child: InkWell(
                      onTap: () {
                        _sortColumn(1, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.alliance,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_sortColumnIndex == 1)
                            Icon(
                              _sortAscending
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  constraints: BoxConstraints(minHeight: 48),
                  child: SizedBox(
                    width: 200,
                    child: InkWell(
                      onTap: () {
                        _sortColumn(2, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.pointsFavour,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_sortColumnIndex == 2)
                            Icon(
                              _sortAscending
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  constraints: BoxConstraints(minHeight: 48),
                  child: SizedBox(
                    width: 200,
                    child: InkWell(
                      onTap: () {
                        _sortColumn(3, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.pointsAgainst,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_sortColumnIndex == 3)
                            Icon(
                              _sortAscending
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  constraints: BoxConstraints(minHeight: 48),
                  child: SizedBox(
                    width: 200,
                    child: InkWell(
                      onTap: () {
                        _sortColumn(4, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.pointsDifference,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_sortColumnIndex == 4)
                            Icon(
                              _sortAscending
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  constraints: BoxConstraints(minHeight: 48),
                  child: SizedBox(
                    width: 150,
                    child: InkWell(
                      onTap: () {
                        _sortColumn(5, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.gamesPlayed,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_sortColumnIndex == 5)
                            Icon(
                              _sortAscending
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  constraints: BoxConstraints(minHeight: 48),
                  child: SizedBox(
                    width: 150,
                    child: InkWell(
                      onTap: () {
                        _sortColumn(6, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.leadersEliminated,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_sortColumnIndex == 6)
                            Icon(
                              _sortAscending
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Text(AppLocalizations.of(context)!.delete),
              ),
            ],
            rows: dataRows,
            headingTextStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            headingRowColor:
                MaterialStateProperty.resolveWith((states) => Colors.grey),
            border: TableBorder.all(
              width: 2.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isOwner)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Background, foregroundColor: ButtonBlack),
              onPressed: () async => {
                setState(
                  () {
                    _addDataRow();
                  },
                )
              },
              child: Icon(Icons.add),
            ),
          SizedBox(width: 10.0),
          if (isOwner)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Background, foregroundColor: ButtonBlack),
              onPressed: () {
                _saveData();
              },
              child: Icon(Icons.save),
            ),
        ],
      ),
    );
  }

  void _addDataRow() {
    List<TextEditingController> controllers = [];
    List<DataCell> cells = [];

    for (int i = 0; i < 7; i++) {
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
      cells.add(DataCell(TextField(controller: controller)));
    }

    cells.add(DataCell(IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {},
    )));

    setState(() {
      dataRows.add(DataRow(cells: cells));
      controllersList.add(controllers);
    });
  }

  void _saveData() async {
    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < dataRows.length; i++) {
      DataRow row = dataRows[i];
      List<dynamic> rowData = [];
      List<TextEditingController> rowControllers = [];

      for (int j = 0; j < row.cells.length - 1; j++) {
        DataCell cell = row.cells[j];
        TextEditingController controller = TextEditingController();
        String cellValue = '';

        if (cell.child is TextField) {
          cellValue = (cell.child as TextField).controller!.text;
          controller.text = cellValue;
        }

        rowControllers.add(controller);
        rowData.add(cellValue);
      }

      controllersList.add(rowControllers);

      Map<String, dynamic> formattedRowData = {
        'tournament': widget.meetingId,
        'player': rowData[0],
        'alliance': rowData[1],
        'victory_points_favour': rowData[2],
        'victory_points_against': rowData[3],
        'difference_points': rowData[4],
        'games_played': rowData[5],
        'leaders_eliminated': rowData[6],
      };

      data.add(formattedRowData);
    }

    var urldelete = Uri.parse(
        'http://10.0.2.2:5432/api/games/tournament/' + widget.meetingId);
    var responsedelete = await http.delete(urldelete);
    print(responsedelete.body);

    var url = Uri.parse('http://10.0.2.2:5432/api/games');

    var request = http.Request('POST', url);
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode(data);

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print(responseBody);

    Map<String, dynamic> response2 = jsonDecode(responseBody);

    // Check if 'nonParticipantUsers' key exists
    if (response2.containsKey('nonParticipantUsers')) {
      // Retrieve the value of 'nonParticipantUsers' key
      List<dynamic> nonParticipantUsers = response2['nonParticipantUsers'];

      // Print the non-participant usernames
      for (var username in nonParticipantUsers) {
        openDialog(AppLocalizations.of(context)!.theUser +
            username +
            AppLocalizations.of(context)!.notParticipant);
      }
    }
  }

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
