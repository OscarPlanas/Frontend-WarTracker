import 'package:flutter/material.dart';

import 'package:war_tracker/models/meeting.dart';
import 'package:war_tracker/controllers/meeting_controller.dart';
import 'package:war_tracker/screens/create_meeting.dart';
import 'package:war_tracker/screens/meeting.dart';
import 'package:get/get.dart';
import 'package:war_tracker/sidebar.dart';
import 'package:war_tracker/constants.dart';
import 'package:war_tracker/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({Key? key}) : super(key: key);

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  Future<List<Meeting>> meetingsFuture = MeetingController().getMeetings();
  ThemeMode _themeMode = ThemeMode.system;

  String _selectedFilter = 'Date'; // Default filter option is 'Date'
  String _selectedDirection = 'Recent'; // Default direction option is 'Recent'
  Future<List<Meeting>>?
      _filteredMeetingsFuture; // Updated Future based on filter
  List<Meeting> _sortedMeetings = []; // Store the sorted meetings
  Map<String, String> _filterTranslations = {};
  Map<String, String> _directionTranslations = {};
  String _searchText = "";
  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _filteredMeetingsFuture = meetingsFuture; // Initialize with default value
    _selectedDirection = 'Recent';
    _updateMeetingsFuture(); // Initialize sorting
  }

  void _loadThemeMode() async {
    // Retrieve the saved theme mode from SharedPreferences
    ThemeMode savedThemeMode = await ThemeHelper.getThemeMode();
    print(savedThemeMode);
    setState(() {
      _themeMode = savedThemeMode;
      _filterTranslations = {
        'Date': AppLocalizations.of(context)!.date,
        'Popularity': AppLocalizations.of(context)!.popularity,
      };
      _directionTranslations = {
        'Recent': AppLocalizations.of(context)!.recent,
        'Far': AppLocalizations.of(context)!.far,
      };
    });
  }

  List<Meeting> displayList = [];

  void updateList(String value) {
    setState(() {
      displayList = displayList
          .where((element) =>
              element.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title: Text((AppLocalizations.of(context)!.tournaments),
            style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                color: _themeMode == ThemeMode.dark ? Colors.grey[700] : null,
                icon: Icon(Icons.filter_list, color: ButtonBlack),
                itemBuilder: (context) {
                  return _filterTranslations.keys.map((String key) {
                    return PopupMenuItem<String>(
                      value: key,
                      child: Text(
                        _filterTranslations[key]!,
                        style: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList();
                },
                onSelected: (String newValue) {
                  setState(() {
                    _selectedFilter = newValue;
                    _updateMeetingsFuture();
                  });
                },
              ),
              SizedBox(width: 16),
              Visibility(
                visible: _filterTranslations[_selectedFilter] ==
                    _filterTranslations['Date'],
                child: PopupMenuButton<String>(
                  color: _themeMode == ThemeMode.dark ? Colors.grey[700] : null,
                  icon: Icon(Icons.sort, color: ButtonBlack),
                  itemBuilder: (context) {
                    return _directionTranslations.keys.map((String key) {
                      return PopupMenuItem<String>(
                        value: key,
                        child: Text(
                          _directionTranslations[key]!,
                          style: TextStyle(
                            color: _themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (String newValue) {
                    setState(() {
                      _selectedDirection = newValue;
                      _updateMeetingsFuture();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  child: TextField(
                    style: _themeMode == ThemeMode.dark
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                      _updateMeetingsFuture();
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchMeeting,
                      hintStyle: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black),
                      prefixIcon: Icon(Icons.search,
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Background), // Change the border color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey), // Change the border color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Meeting>>(
                  future: _filteredMeetingsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Meeting> filteredMeetings =
                          _sortedMeetings.where((meeting) {
                        return meeting.title
                            .toLowerCase()
                            .contains(_searchText.toLowerCase());
                      }).toList();
                      return ListView.builder(
                        itemCount: filteredMeetings.length,
                        itemBuilder: (context, index) {
                          Meeting meeting = filteredMeetings[index];
                          return InkWell(
                            onTap: () {
                              Get.to(MeetingScreen(meeting));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: _themeMode == ThemeMode.dark
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 1,
                                        color: _themeMode == ThemeMode.dark
                                            ? Colors.white
                                            : Colors.grey[300]!,
                                        offset: Offset(0, 2),
                                        spreadRadius: 1),
                                  ],
                                ),
                                height: height * 0.15,
                                margin: EdgeInsets.only(
                                    bottom: height * 0.01,
                                    top: height * 0.01,
                                    left: width * 0.02,
                                    right: width * 0.02),
                                child: Row(
                                  children: [
                                    Container(
                                      width: width * 0.3,
                                      height: height * 0.15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(meeting.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                        height: height * 0.15,
                                        width: width * 0.45,
                                        padding: EdgeInsets.symmetric(
                                            vertical: height * 0.01,
                                            horizontal: height * 0.02),
                                        child: Column(
                                          children: [
                                            Text(
                                              meeting.title,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    _themeMode == ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              textAlign: TextAlign.left,
                                              meeting.date,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    _themeMode == ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              meeting.location,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    _themeMode == ThemeMode.dark
                                                        ? Colors.white
                                                        : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                )),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAll(CreateMeeting());
        },
        child: Text(
          AppLocalizations.of(context)!.createMeeting,
          style: TextStyle(
              fontSize: 12, color: ButtonBlack, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Background,
      ),
    );
  }

  void _updateMeetingsFuture() {
    setState(() {
      if (_selectedFilter == 'Date') {
        _filteredMeetingsFuture = MeetingController().getMeetings();
        _filteredMeetingsFuture = _filteredMeetingsFuture!.then((meetings) {
          if (_selectedDirection == 'Far') {
            meetings.sort((a, b) {
              DateTime dateA = DateFormat('yyyy-MM-dd').parse(a.date);
              DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.date);
              return dateB.compareTo(dateA);
            });
          } else if (_selectedDirection == 'Recent') {
            meetings.sort((a, b) {
              DateTime dateA = DateFormat('yyyy-MM-dd').parse(a.date);
              DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.date);
              return dateA.compareTo(dateB);
            });
          }
          _sortedMeetings = List.from(meetings);
          displayList = List.from(meetings);
          return meetings;
        });
      } else if (_selectedFilter == 'Popularity') {
        _filteredMeetingsFuture = MeetingController().getMeetings();
        _filteredMeetingsFuture = _filteredMeetingsFuture!.then((meetings) {
          meetings.sort((a, b) {
            int likesA = a.participants.length;
            int likesB = b.participants.length;

            if (likesA == likesB) {
              DateTime dateA = DateFormat('yyyy-MM-dd').parse(a.date);
              DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.date);
              return dateB.compareTo(dateA);
            }
            return likesB.compareTo(likesA);
          });
          _sortedMeetings = List.from(meetings);
          displayList = List.from(meetings);
          return meetings;
        });
      }
    });
  }
}
