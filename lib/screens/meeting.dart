import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/meeting_controller.dart';
import 'package:frontend/controllers/chat_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/Chat.dart';
import 'package:frontend/models/meeting.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/edit_meeting.dart';
import 'package:frontend/screens/game.dart';
import 'package:frontend/screens/messages.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/screens/tournaments.dart';
import 'package:frontend/widgets/comment_meeting.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/controllers/report_controller.dart';
import 'package:intl/intl.dart';

class MeetingScreen extends StatefulWidget {
  final Meeting meeting;
  MeetingScreen(this.meeting);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  MeetingController meetingController = Get.put(MeetingController());
  ChatController chatController = Get.put(ChatController());

  var listParticipants = 0;

  bool _flag2 = false;

  bool isOwner = false;

  ThemeMode _themeMode = ThemeMode.system;
  ReportController reportController = ReportController();

  @override
  void initState() {
    super.initState();

    meetingController.userIsParticipant(widget.meeting.id);

    isParticipant();
    checkIsOwner();
    updateParticipantsList();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    // Retrieve the saved theme mode from SharedPreferences
    ThemeMode savedThemeMode = await ThemeHelper.getThemeMode();
    print(savedThemeMode);
    setState(() {
      _themeMode = savedThemeMode;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(TournamentScreen()),
        ),
        title: Text(widget.meeting.title, style: TextStyle(color: ButtonBlack)),
        iconTheme: IconThemeData(color: ButtonBlack),
        backgroundColor: Background,
        actions: [
          // Add a report button to the app bar
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () {
              sendReportMeeting();
            },
          ),
        ],
      ),
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
              foregroundDecoration: const BoxDecoration(color: Colors.black26),
              height: 400,
              child: Image.network(
                widget.meeting.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              )),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.meeting.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 16.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(32.0),
                  color: _themeMode == ThemeMode.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      color: _themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.grey,
                                    )),
                                    TextSpan(
                                        text: widget.meeting.location,
                                        style: TextStyle(
                                          color: _themeMode == ThemeMode.dark
                                              ? Colors.white
                                              : Colors.grey,
                                        )),
                                  ]),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.date_range,
                                      size: 16.0,
                                      color: _themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.grey,
                                    )),
                                    TextSpan(
                                        text: widget.meeting.date,
                                        style: TextStyle(
                                            color: _themeMode == ThemeMode.dark
                                                ? Colors.white
                                                : Colors.grey)),
                                  ]),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.person,
                                        size: 16.0,
                                        color: _themeMode == ThemeMode.dark
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .organizedBy,
                                        style: TextStyle(
                                            color: _themeMode == ThemeMode.dark
                                                ? Colors.white
                                                : Colors.grey)),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading:
                                                          Icon(Icons.person),
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .viewProfile),
                                                      onTap: () {
                                                        navigateToUserProfile(
                                                            widget.meeting
                                                                    .organizer[
                                                                "_id"]);
                                                      },
                                                    ),
                                                    if (currentUser.id !=
                                                        widget.meeting
                                                            .organizer["_id"])
                                                      ListTile(
                                                        leading:
                                                            Icon(Icons.message),
                                                        title: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .sendMessage),
                                                        onTap: () {
                                                          print(
                                                              "Sending message to user");
                                                          sendMessageToUser(
                                                              widget.meeting
                                                                      .organizer[
                                                                  "_id"]);
                                                        },
                                                      ),
                                                    if (currentUser.id !=
                                                        widget.meeting
                                                            .organizer["_id"])
                                                      ListTile(
                                                        leading:
                                                            Icon(Icons.report),
                                                        title: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .reportUser),
                                                        onTap: () {
                                                          sendReportUser();
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          widget.meeting.organizer["username"],
                                          style: TextStyle(
                                            color: _themeMode == ThemeMode.dark
                                                ? Colors.white
                                                : ButtonBlack,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                widget.meeting.registration_fee.toString() +
                                    " €",
                                style: TextStyle(
                                    color: _themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : ButtonBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              Text(
                                AppLocalizations.of(context)!.registrationFee,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: _themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {
                            setState(() {
                              _flag2 = !_flag2;
                            }),
                            if (_flag2)
                              {
                                meetingController
                                    .deleteParticipant(widget.meeting.id),
                                listParticipants -= 1,
                                deleteEventMeeting(widget.meeting.id),
                              }
                            else
                              {
                                meetingController
                                    .addParticipant(widget.meeting.id),
                                listParticipants += 1,
                                createEvent(widget.meeting.title),
                              },
                          },
                          child: Text(_flag2
                              ? AppLocalizations.of(context)!.signUp
                              : AppLocalizations.of(context)!.signOut),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            backgroundColor: _flag2 ? Background : Colors.red,
                            foregroundColor: ButtonBlack,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 32.0,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8.0),
                      Text(
                          AppLocalizations.of(context)!
                              .participantsTotals(listParticipants.toString()),
                          style: TextStyle(
                              color: _themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.grey)),
                      const SizedBox(height: 30.0),
                      Text(
                        AppLocalizations.of(context)!.meetingPlace,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: _themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                      Container(
                        width: 350, // Adjust the width as needed
                        height: 200, // Adjust the height as needed
                        child: FlutterMap(
                          options: MapOptions(
                            center:
                                LatLng(widget.meeting.lat, widget.meeting.lng),
                            zoom: 13.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 40.0,
                                  height: 40.0,
                                  point: LatLng(
                                      widget.meeting.lat, widget.meeting.lng),
                                  builder: (ctx) => Container(
                                    child: Icon(Icons.location_on,
                                        color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        AppLocalizations.of(context)!.descriptionMeetingBefore,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: _themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        widget.meeting.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0,
                            color: _themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        AppLocalizations.of(context)!.comments,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Comment section
                      Card(
                        color: Background,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: CommentMeeting(widget.meeting),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isOwner)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _themeMode == ThemeMode.dark
                      ? Colors.grey[700]
                      : ButtonBlack,
                  foregroundColor: Background),
              onPressed: () async {
                final updatedMeeting =
                    await Get.to(EditMeeting(widget.meeting));
                if (updatedMeeting != null) {
                  setState(() {
                    // Update the meeting object with the new data
                    widget.meeting.title = updatedMeeting.title;
                    widget.meeting.location = updatedMeeting.location;
                    widget.meeting.date = updatedMeeting.date;
                    widget.meeting.registration_fee =
                        updatedMeeting.registration_fee;

                    widget.meeting.description = updatedMeeting.description;
                    widget.meeting.imageUrl = updatedMeeting.imageUrl;
                    widget.meeting.lat = updatedMeeting.lat;
                    widget.meeting.lng = updatedMeeting.lng;
                  });
                }
              },
              child: Icon(Icons.edit),
            ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              Get.to(GameScreen(widget.meeting.id));
            },
            child: Text(
              AppLocalizations.of(context)!.gameTable,
              style: TextStyle(color: ButtonBlack, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Background,
          ),
        ],
      ),
    );
  }

  Future<void> isParticipant() async {
    MeetingController meetingController = await Get.put(MeetingController());

    bool _isParticipant =
        await meetingController.userIsParticipant(widget.meeting.id);

    if (_isParticipant == true) {
      setState(() {
        _flag2 = false;
      });
    } else {
      setState(() {
        _flag2 = true;
      });
    }
  }

  Future<void> checkIsOwner() async {
    var url =
        Uri.parse('http://10.0.2.2:5432/api/meetings/' + widget.meeting.id);
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      currentUser.username == data['organizer']['username']
          ? isOwner = true
          : isOwner = false;
    });
  }

  Future<void> updateParticipantsList() async {
    final meeting = widget.meeting;
    final url = Uri.parse('http://10.0.2.2:5432/api/meetings/${meeting.id}');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    final participants = data['participants'];

    setState(() {
      listParticipants = participants.length;
      print("listParticipants: $listParticipants");
    });
  }

  Future<void> navigateToUserProfile(idUser) async {
    final data =
        await http.get(Uri.parse('http://10.0.2.2:5432/api/users/' + idUser));
    var jsonData = json.decode(data.body);

    User user = User(
      id: jsonData["_id"],
      username: jsonData["username"],
      password: jsonData["password"],
      email: jsonData["email"],
      date: jsonData["date"],
      name: jsonData["name"],
      imageUrl: jsonData["imageUrl"],
      backgroundImageUrl: jsonData["backgroundImageUrl"],
      about: jsonData["about"],
      meetingsFollowed: jsonData["meetingsFollowed"],
      followers: jsonData["followers"] ??
          [], // This is a list of IDs, so it should be initialized as an empty list
      following: jsonData["following"] ?? [],
    );

    Get.to(Profile(user));
  }

  Future<void> sendMessageToUser(recipientId) async {
    print("Sending message to user with ID: " + recipientId);
    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/users/' + recipientId));
    var jsonData = json.decode(data.body);

    User user = User(
      id: jsonData["_id"],
      username: jsonData["username"],
      password: jsonData["password"],
      email: jsonData["email"],
      date: jsonData["date"],
      name: jsonData["name"],
      imageUrl: jsonData["imageUrl"],
      backgroundImageUrl: jsonData["backgroundImageUrl"],
      about: jsonData["about"],
      meetingsFollowed: jsonData["meetingsFollowed"],
      followers: jsonData["followers"] ?? [],
      following: jsonData["following"] ?? [],
    );

    ChatModel? chat = await chatController.getChat(currentUser.id, user.id);
    if (chat == null) {
      // If the chat is null, it means no chat exists, so we create a new chat
      chatController.createChat(currentUser.id, user.id);
    }

    Get.to(MessagesScreen(user));
  }

  void sendReportMeeting() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeMode == ThemeMode.dark
              ? Color.fromARGB(255, 72, 70, 70)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(AppLocalizations.of(context)!.report,
              style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black)),
          content: Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              children: [
                TextField(
                  controller: reportController.reasonController,
                  style: TextStyle(
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.reasonReport,
                    hintStyle: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (reportController.reasonController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!.plsReason,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: ButtonBlack,
                      textColor: Background,
                      fontSize: 16.0);
                } else {
                  await reportController
                      .createReport("Meeting", widget.meeting.id)
                      .then((value) {
                    if (value == "Report saved") {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.reportSent,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: ButtonBlack,
                          textColor: Background,
                          fontSize: 16.0);
                      Get.back();
                    } else {
                      print(value);
                      Fluttertoast.showToast(
                          msg: value,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: ButtonBlack,
                          textColor: Background,
                          fontSize: 16.0);
                    }
                  });
                }
              },
              child: Text(AppLocalizations.of(context)!.confirm,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void sendReportUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeMode == ThemeMode.dark
              ? Color.fromARGB(255, 72, 70, 70)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(AppLocalizations.of(context)!.report,
              style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black)),
          content: Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              children: [
                TextField(
                  controller: reportController.reasonController,
                  style: TextStyle(
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.reasonReport,
                    hintStyle: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (reportController.reasonController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!.plsReason,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: ButtonBlack,
                      textColor: Background,
                      fontSize: 16.0);
                } else {
                  await reportController
                      .createReport("User", widget.meeting.organizer["_id"])
                      .then((value) {
                    if (value == "Report saved") {
                      Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.reportSent,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: ButtonBlack,
                          textColor: Background,
                          fontSize: 16.0);
                      Get.back();
                    } else {
                      print(value);
                      Fluttertoast.showToast(
                          msg: value,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: ButtonBlack,
                          textColor: Background,
                          fontSize: 16.0);
                    }
                  });
                }
              },
              child: Text(AppLocalizations.of(context)!.confirm,
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> createEvent(String eventName) async {
    print("Creating event");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5432/api/events/createevent'),
      body: {
        'title': eventName,
        'date': DateFormat('yyyy-MM-dd')
            .parse(widget.meeting.date)
            .toUtc()
            .toIso8601String(),
        'user': currentUser.id,
        'meeting': widget.meeting.id,
      },
    );

    if (response.statusCode == 200) {
      // Event created successfully
      print("Event created successfully");
    } else {
      // Handle error
      print('Error creating event: ${response.body}');
    }
  }

  Future<void> deleteEventMeeting(String meetingid) async {
    final response = await http.delete(
      Uri.parse(
          'http://10.0.2.2:5432/api/events/deleteeventbymeetingid/$meetingid'),
    );

    if (response.statusCode == 200) {
      // Event deleted successfully
      print("Event deleted successfully");
    } else {
      // Handle error
      print('Error deleting event: ${response.body}');
    }
  }
}
