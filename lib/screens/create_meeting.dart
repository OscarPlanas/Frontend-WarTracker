import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/meeting_controller.dart';
import 'package:frontend/screens/tournaments.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:frontend/data/data.dart';
import 'package:dio/dio.dart';
import 'package:frontend/theme_provider.dart';

class CreateMeeting extends StatefulWidget {
  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  MeetingController meetingController = MeetingController();

  bool _validatetitle = false;
  bool _validatedesc = false;
  bool _validatelocation = false;
  bool _validatedate = false;
  bool _validatefee = false;
  bool isloading = false;
  DateTime selectedDate = DateTime.now();

  ImageProvider? selectedImage; // Store the selected image

  final cloudinary = CloudinaryPublic("dagbarc6g", 'WarTracker', cache: false);

  XFile? image;
  final ImagePicker picker = ImagePicker();

  ThemeMode _themeMode = ThemeMode.system;

  Future uploadImage() async {
    const url =
        "https://api.cloudinary.com/v1_1/dagbarc6g/auto/upload/w_200,h_200,c_fill,r_max";
    print(url);
    var image = await ImagePicker.platform.getImage(source: ImageSource.camera);

    if (image == null) {
      // No image selected, return without further processing
      return;
    }

    setState(() {
      isloading = true;
    });
    Dio dio = Dio();
    print(dio);
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
      ),
      "upload_preset": "WarTracker",
      "cloud_name": "dagbarc6g",
    });
    print(formData);
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
    print(url);
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
    print(dio);
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
      ),
      "upload_preset": "WarTracker",
      "cloud_name": "dagbarc6g",
    });
    print(formData);
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

  @override
  void initState() {
    super.initState();
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

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: _themeMode == ThemeMode.dark
                ? Color.fromARGB(255, 32, 30, 30)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select',
                style: TextStyle(
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black)),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Background,
                    ),
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.of(context).pop();
                      uploadImage2();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image, color: ButtonBlack),
                        Text('From Gallery',
                            style: TextStyle(color: ButtonBlack)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Background,
                    ),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.of(context).pop();
                      uploadImage();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera, color: ButtonBlack),
                        Text('From Camera',
                            style: TextStyle(color: ButtonBlack)),
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
  Widget build(BuildContext context) {
    if (change != "") {
      currentPhoto = change;
    }
    return Scaffold(
        backgroundColor:
            _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TournamentScreen();
                  }))),
          title: Text("Create a meeting", style: TextStyle(color: ButtonBlack)),
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
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 150,
              decoration: BoxDecoration(
                color: _themeMode == ThemeMode.dark
                    ? Colors.grey[800]
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
                image: selectedImage != null
                    ? DecorationImage(
                        image: selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              width: MediaQuery.of(context).size.width,
              child: selectedImage == null
                  ? Icon(Icons.add_a_photo,
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black)
                  : null,
            ),
          ),
          SizedBox(height: 12),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: <Widget>[
              TextField(
                controller: meetingController.titleController,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Background),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Background),
                    ),
                    hintText: "Write the title of your meeting",
                    hintStyle: TextStyle(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.grey[800]),
                    errorText: _validatetitle ? 'Can\'t Be Empty' : null,
                    counterStyle: TextStyle(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold)),
                style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                maxLength: 30,
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: meetingController.feeController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Background),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Background),
                        ),
                        hintText: "Inscription fee in €",
                        hintStyle: TextStyle(
                            color: _themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.grey[800]),
                        errorText: _validatefee ? 'Can\'t Be Empty' : null,
                        counterStyle: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
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
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Background),
                        ),
                        hintText: "Location of the meeting",
                        hintStyle: TextStyle(
                            color: _themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.grey[800]),
                        errorText: _validatelocation ? 'Can\'t Be Empty' : null,
                        counterStyle: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      maxLength: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextField(
                controller: meetingController.dateController,
                onTap: () async {
                  // Show date picker dialog
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2024),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData().copyWith(
                          primaryColor: Colors
                              .green, // Set the color of the header and selected date
                          colorScheme: _themeMode == ThemeMode.dark
                              ? ColorScheme.dark(
                                  brightness: Brightness.dark,
                                  primary: Background,
                                  onPrimary: Colors.black)
                              : ColorScheme.light(
                                  primary: Background,
                                  onPrimary: Colors
                                      .black), // Set the color of the selected date circle
                          dialogBackgroundColor: _themeMode == ThemeMode.dark
                              ? Colors.grey[900]
                              : Colors.white,
                          buttonTheme: ButtonThemeData(
                            textTheme: ButtonTextTheme.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    setState(() {
                      // Store the selected date
                      selectedDate = pickedDate;
                      // Update the text field with the selected date
                      meetingController.dateController.text =
                          DateFormat('yyyy-MM-dd').format(selectedDate);
                    });
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Background),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Background),
                  ),
                  hintText: "Date of the meeting",
                  hintStyle: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.grey[800]),
                  errorText: _validatedate ? 'Can\'t Be Empty' : null,
                  counterStyle: TextStyle(
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: meetingController.descriptionController,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Background),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Background),
                    ),
                    hintText: "Write the description",
                    hintStyle: TextStyle(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.grey[800]),
                    errorText: _validatedesc ? 'Can\'t Be Empty' : null,
                    counterStyle: TextStyle(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold)),
                style: TextStyle(
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                maxLength: 1000,
                maxLines: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Background,
                ),
                onPressed: () async => {
                  setState(() {
                    meetingController.titleController.text.isEmpty
                        ? _validatetitle = true
                        : _validatetitle = false;
                    meetingController.descriptionController.text.isEmpty
                        ? _validatedesc = true
                        : _validatedesc = false;
                    meetingController.locationController.text.isEmpty
                        ? _validatelocation = true
                        : _validatelocation = false;
                    meetingController.dateController.text.isEmpty
                        ? _validatedate = true
                        : _validatedate = false;
                    meetingController.feeController.text.isEmpty
                        ? _validatefee = true
                        : _validatefee = false;
                  }),
                  if (meetingController.titleController.text.isNotEmpty &&
                      meetingController.descriptionController.text.isNotEmpty &&
                      meetingController.feeController.text.isNotEmpty &&
                      meetingController.locationController.text.isNotEmpty &&
                      meetingController.dateController.text.isNotEmpty &&
                      meetingController.locationController.text.isNotEmpty &&
                      meetingController.dateController.text.isNotEmpty &&
                      selectedImage != null)
                    {
                      await meetingController.createMeeting(currentPhoto),
                      change = "",
                      currentPhoto = "",
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TournamentScreen();
                      })),
                    }
                  else if (selectedImage == null)
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: _themeMode == ThemeMode.dark
                                ? Color.fromARGB(255, 32, 30, 30)
                                : Colors.white,
                            title: Text('Error',
                                style: TextStyle(
                                    color: _themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black)),
                            content: Text('Please select an image.',
                                style: TextStyle(
                                    color: _themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black)),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    }
                },
                child: Text(
                  'Submit',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ]),
          )
        ])));
  }
}
