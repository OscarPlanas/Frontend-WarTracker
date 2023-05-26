import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

  Future<List<Map<String, dynamic>>> fetchGames(String meetingId) async {
    var url =
        Uri.parse('http://10.0.2.2:5432/api/games/tournament/' + meetingId);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> games =
          List<Map<String, dynamic>>.from(data);
      print(games);
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
        DataRow newRow = DataRow(
          cells: [
            //DataCell(Text(game['tournament']['title'])),
            DataCell(Text(game['player']['username'])),
            DataCell(Text(game['alliance'])),
            DataCell(Text(game['victory_points_favour'].toString())),
            DataCell(Text(game['victory_points_against'].toString())),
            DataCell(Text(game['difference_points'].toString())),
            DataCell(Text(game['games_played'].toString())),
            DataCell(Text(game['leaders_eliminated'].toString())),
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

        // Handle null values
        if (valueA == "null" && valueB == "null") {
          return 0; // Both values are null, consider them equal
        } else if (valueA == "null") {
          return ascending ? -1 : 1; // Null value is considered lower
        } else if (valueB == "null") {
          return ascending ? 1 : -1; // Null value is considered lower
        }

        // Compare non-null values
        return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
      });
    });
  }

  dynamic _extractValue(Widget child) {
    if (child is Text) {
      final textValue = child.data;
      final parsedInt = int.tryParse(textValue ?? '');
      return parsedInt != null ? parsedInt : textValue;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    _updateTableData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Game Screen', style: TextStyle(color: ButtonBlack)),
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
              //DataColumn(label: Text('tournament')),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  constraints: BoxConstraints(minHeight: 48),
                  child: SizedBox(
                    width: 100, // Set the desired width
                    child: InkWell(
                      onTap: () {
                        _sortColumn(0, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Player',
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
                    width: 100, // Set the desired width
                    child: InkWell(
                      onTap: () {
                        _sortColumn(1, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Alliance',
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
                    width: 150, // Set the desired width
                    child: InkWell(
                      onTap: () {
                        _sortColumn(2, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Victory points in favour',
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
                    width: 150, // Set the desired width
                    child: InkWell(
                      onTap: () {
                        _sortColumn(3, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Victory points against',
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
                    width: 150, // Set the desired width
                    child: InkWell(
                      onTap: () {
                        _sortColumn(4, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Points difference',
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
                    width: 100, // Set the desired width
                    child: InkWell(
                      onTap: () {
                        _sortColumn(5, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Games played',
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
                    width: 150, // Set the desired width
                    child: InkWell(
                      onTap: () {
                        _sortColumn(6, !_sortAscending);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Leaders eliminated',
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

    setState(() {
      dataRows.add(DataRow(cells: cells));
    });
  }

  void _saveData() async {
    List<Map<String, dynamic>> data = [];

    for (DataRow row in dataRows) {
      List<dynamic> rowData = [];
      for (DataCell cell in row.cells) {
        if (cell.child is TextField) {
          TextField textField = cell.child as TextField;
          rowData.add(textField.controller!.text);
        } else {
          rowData.add((cell.child as Text).data);
        }
      }

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
    print(jsonEncode(data));
    print(data);
    //print(response.body);
  }
}
