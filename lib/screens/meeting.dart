import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/meeting.dart';
import 'package:frontend/controllers/meeting_controller.dart';
import 'package:get/get.dart';

class MeetingScreen extends StatefulWidget {
  final Meeting meeting;
  MeetingScreen(this.meeting);
  //const MeetingScreen({Key? key, Meeting? meeting}) : super(key: key);
  //final Meeting meeting;
  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
//class _MeetingScreenState extends State<MeetingScreen> {
  static final String path = "lib/screens/meeting.dart";
  //final Meeting meeting;
  var meeting;
  //final Meeting meeting = Get.arguments;
  //MeetingScreen(this.meeting);
  final String image = "assets/images/groguplaceholder.png";
  MeetingController meetingController = Get.put(MeetingController());
  bool _flag2 = false;

  @override
  void initState() {
    super.initState();
    meetingController.getMeetings();
    meeting = widget.meeting;
    meetingController.userIsParticipant(meeting.id);
    isParticipant();
  }

  /*Future<bool> new2() async {
    _flag2 = await isParticipant();
    return _flag2;
  }*/

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meeting.title, style: TextStyle(color: ButtonBlack)),
        iconTheme: IconThemeData(color: ButtonBlack),
        backgroundColor: Background,
      ),
      body: Stack(
        children: <Widget>[
          Container(
              foregroundDecoration: const BoxDecoration(color: Colors.black26),
              height: 400,
              child: Image.asset(image, fit: BoxFit.cover)),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    meeting.title,
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
                      /*decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: const Text(
                        "8.4/85 reviews",
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),*/
                    ),
                    const Spacer(),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    )
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
                                Row(
                                  children: const <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: ButtonBlack,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: ButtonBlack,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: ButtonBlack,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: ButtonBlack,
                                    ),
                                    Icon(
                                      Icons.star_border,
                                      color: ButtonBlack,
                                    ),
                                  ],
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      color: Colors.grey,
                                    )),
                                    TextSpan(text: meeting.location),
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
                                    TextSpan(text: meeting.date),
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
                                            meeting.organizer["username"]),
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
                                meeting.registration_fee.toString() + " €",
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
                            setState(
                              () => _flag2 = !_flag2,
                            ),
                            _flag2
                                ? meetingController
                                    .deleteParticipant(meeting.id)
                                : meetingController.addParticipant(meeting.id),
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
                          /*
                          onPressed: () => setState(() => _flag = !_flag),
                          child: Text(_flag ? 'Sign Up' : 'Sign Out');*/
                          /*meetingController.addParticipant(meeting.id);
                            setState(() => _flag = !_flag);
                            
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _flag ? Colors.green : Colors.red,
                            );*/
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        "Description".toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        meeting.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14.0),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> isParticipant() async {
    print("entra en lo nuevo de meeting participant");
    MeetingController meetingController = await Get.put(MeetingController());
    print(meeting.id);
    print(meetingController);
    bool _isParticipant = await meetingController.userIsParticipant(meeting.id);
    print("true o false");
    print(_isParticipant);
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
}
