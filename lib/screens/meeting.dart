import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/meeting_controller.dart';
import 'package:frontend/models/meeting.dart';
import 'package:frontend/screens/edit_meeting.dart';
import 'package:frontend/screens/game.dart';
import 'package:frontend/screens/tournaments.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/comment_meeting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/data/data.dart';

class MeetingScreen extends StatefulWidget {
  final Meeting meeting;
  MeetingScreen(this.meeting);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  MeetingController meetingController = Get.put(MeetingController());

  //var meeting;
  var listParticipants = 0;

  bool _flag2 = false;

  bool isOwner = false;

  @override
  void initState() {
    super.initState();

    //meetingController.getMeetings();
    //meeting = widget.meeting;
    meetingController.userIsParticipant(widget.meeting.id);

    isParticipant();
    checkIsOwner();
    updateParticipantsList();
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
      ),
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
                  color: Colors.white,
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
                                      color: Colors.grey,
                                    )),
                                    TextSpan(text: widget.meeting.location),
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
                                      color: Colors.grey,
                                    )),
                                    TextSpan(text: widget.meeting.date),
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
                                      color: Colors.grey,
                                    )),
                                    TextSpan(
                                        text: "Organized by " +
                                            widget
                                                .meeting.organizer["username"]),
                                  ]),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                widget.meeting.registration_fee.toString() +
                                    " €",
                                style: TextStyle(
                                    color: ButtonBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              Text(
                                "/registration",
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
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
                              }
                            else
                              {
                                meetingController
                                    .addParticipant(widget.meeting.id),
                                listParticipants += 1,
                              },
                            //updateParticipantsList(),
                          },
                          child: Text(_flag2 ? 'Sign Up' : 'Sign Out'),
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
                          "There are " +
                              listParticipants.toString() +
                              " participants",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30.0),
                      Text(
                        "Description".toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        widget.meeting.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Comments",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
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
                  backgroundColor: ButtonBlack, foregroundColor: Background),
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
              "Game table",
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
        //listParticipants += 1;
      });
    } else {
      setState(() {
        _flag2 = true;
        //listParticipants -= 1;
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
}
