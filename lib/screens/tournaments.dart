import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/meeting.dart';
import 'package:frontend/controllers/meeting_controller.dart';
import 'package:frontend/screens/meeting.dart';
import 'package:get/get.dart';
import 'package:frontend/sidebar.dart';
import 'package:frontend/constants.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({Key? key}) : super(key: key);

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  Future<List<Meeting>> meetingsFuture = MeetingController().getMeetings();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title:
            const Text(('Tournaments'), style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
      ),
      //child: Scaffold(
      //drawer: Sidebar(),

      body: Stack(
        children: [
          FutureBuilder<List<Meeting>>(
            future: meetingsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(

                    //color: Colors.white,
                    //margin: EdgeInsets.only(top: height * 0.08),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Meeting meeting = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          Get.to(MeetingScreen(meeting));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 1,
                                    color: Colors.grey,
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
                                      image: AssetImage(
                                          "assets/images/groguplaceholder.png"),
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
                                          ),
                                        ),
                                      ],
                                    )),
                                Flexible(
                                    fit: FlexFit.tight,
                                    /*height: height * 0.15,
                                    width: width * 0.4,
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.01,
                                        horizontal: height * 0.02),*/
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.left,
                                          meeting.date,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          meeting.location,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
