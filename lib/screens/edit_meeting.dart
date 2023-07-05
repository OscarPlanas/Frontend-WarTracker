import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/meeting_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/meeting.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditMeeting extends StatefulWidget {
  final Meeting meeting;

  EditMeeting(this.meeting) : selectedImage = NetworkImage(meeting.imageUrl);
  final ImageProvider selectedImage;

  @override
  State<EditMeeting> createState() => _EditMeetingState();
}

class _EditMeetingState extends State<EditMeeting> {
  MeetingController meetingController = MeetingController();

  bool _validatetitle = false;
  bool _validatefee = false;
  bool _validatelocation = false;
  bool _validatedate = false;
  bool _validatedesc = false;
  DateTime selectedDate = DateTime.now();

  bool isloading = false;
  File? imageFile;

  final cloudinary = CloudinaryPublic("dagbarc6g", 'WarTracker', cache: false);

  XFile? image;
  final ImagePicker picker = ImagePicker();
  ImageProvider? selectedImage; // Store the selected image

  Future uploadImage() async {
    const url =
        "https://api.cloudinary.com/v1_1/dagbarc6g/auto/upload/w_200,h_200,c_fill,r_max";
    var image = await ImagePicker.platform.getImage(source: ImageSource.camera);

    if (image == null) {
      // No image selected, return without further processing
      return;
    }

    setState(() {
      isloading = true;
    });
    Dio dio = Dio();
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
      ),
      "upload_preset": "WarTracker",
      "cloud_name": "dagbarc6g",
    });
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path,
              resourceType: CloudinaryResourceType.Image));
// Set the selectedImage with the uploaded image
      setState(() {
        selectedImage = NetworkImage(response.secureUrl);
      });
      currentPhoto = response.secureUrl; // Set the currentPhoto value
      change = response.secureUrl;
    } catch (e) {
      print(e);
    }
  }

  Future uploadImage2() async {
    const url =
        "https://api.cloudinary.com/v1_1/dagbarc6g/auto/upload/w_200,h_200,c_fill,r_max";
    var image =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (image == null) {
      // No image selected, return without further processing
      return;
    }

    setState(() {
      isloading = true;
    });

    Dio dio = Dio();
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
      ),
      "upload_preset": "WarTracker",
      "cloud_name": "dagbarc6g",
    });
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path,
              resourceType: CloudinaryResourceType.Image));
      // Set the selectedImage with the uploaded image
      setState(() {
        selectedImage = NetworkImage(response.secureUrl);
      });
      currentPhoto = response.secureUrl; // Set the currentPhoto value
      change = response.secureUrl;
    } catch (e) {
      print(e);
    }
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.of(context).pop();
                      uploadImage2();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.of(context).pop();
                      uploadImage();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    // Set initial values for the text controllers
    meetingController.titleController.text = widget.meeting.title;
    meetingController.descriptionController.text = widget.meeting.description;
    meetingController.feeController.text =
        widget.meeting.registration_fee.toString();
    meetingController.locationController.text = widget.meeting.location;
    meetingController.dateController.text = widget.meeting.date;
  }

  @override
  Widget build(BuildContext context) {
    if (change != "") {
      currentPhoto = change;
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title:
              Text("Edit your meeting", style: TextStyle(color: ButtonBlack)),
          iconTheme: IconThemeData(color: ButtonBlack),
          backgroundColor: Background,
        ),
        body: Container(
          child: ListView(children: <Widget>[
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                myAlert();
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: selectedImage != null
                          ? DecorationImage(
                              image: selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : widget.meeting.imageUrl != ""
                              ? DecorationImage(
                                  image: NetworkImage(widget.meeting.imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: selectedImage == null
                        ? Icon(Icons.add_a_photo, color: Colors.black)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo, color: Colors.black),
                        onPressed: () {
                          myAlert();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: <Widget>[
                TextField(
                  controller: meetingController.titleController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      errorText: _validatetitle ? 'Can\'t Be Empty' : null,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      counterStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                  maxLength: 30,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: meetingController.feeController,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Background),
                            ),
                            errorText: _validatefee ? 'Can\'t Be Empty' : null,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Background),
                            ),
                            counterStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold)),
                        maxLength: 3,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: meetingController.locationController,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Background),
                            ),
                            errorText:
                                _validatelocation ? 'Can\'t Be Empty' : null,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Background),
                            ),
                            counterStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold)),
                        maxLength: 40,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                TextField(
                  controller: meetingController.dateController,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateFormat("yyyy-MM-dd")
                            .parseStrict(meetingController.dateController.text),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2028));
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;

                        meetingController.dateController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                      });
                    }
                  },
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      errorText: _validatedate ? 'Can\'t Be Empty' : null,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      counterStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                ),
                TextField(
                  controller: meetingController.descriptionController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      errorText: _validatedesc ? 'Can\'t Be Empty' : null,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      counterStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                  maxLength: 1000,
                  maxLines: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Background,
                  ),
                  onPressed: () async {
                    setState(() {
                      meetingController.titleController.text.isEmpty
                          ? _validatetitle = true
                          : _validatetitle = false;
                      meetingController.descriptionController.text.isEmpty
                          ? _validatedesc = true
                          : _validatedesc = false;
                      meetingController.feeController.text.isEmpty
                          ? _validatefee = true
                          : _validatefee = false;
                      meetingController.locationController.text.isEmpty
                          ? _validatelocation = true
                          : _validatelocation = false;
                      meetingController.dateController.text.isEmpty
                          ? _validatedate = true
                          : _validatedate = false;
                    });
                    if (currentPhoto == "" || currentPhoto == " ") {
                      currentPhoto = widget.meeting.imageUrl;
                    }
                    if (meetingController.titleController.text.isNotEmpty &&
                        meetingController
                            .descriptionController.text.isNotEmpty &&
                        meetingController.feeController.text.isNotEmpty &&
                        meetingController.locationController.text.isNotEmpty &&
                        meetingController.dateController.text.isNotEmpty) {
                      meetingController.editMeeting(
                          widget.meeting.id, currentPhoto);
                      // Create the updated blog object
                      Meeting updatedMeeting = Meeting(
                        organizer: widget.meeting.organizer,
                        id: widget.meeting.id,
                        title: meetingController.titleController.text,
                        description:
                            meetingController.descriptionController.text,
                        location: meetingController.locationController.text,
                        registration_fee:
                            int.parse(meetingController.feeController.text),
                        date: meetingController.dateController.text,
                        participants: widget.meeting.participants,
                        imageUrl: currentPhoto,
                      );
                      change = "";
                      currentPhoto = "";
                      // Pass the updated blog as a separate parameter
                      Navigator.pop(context, updatedMeeting);
                    }
                  },
                  child: Text(
                    'Submit',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ]),
            ),
          ]),
        ));
  }
}
