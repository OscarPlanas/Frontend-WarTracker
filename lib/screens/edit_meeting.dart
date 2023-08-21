import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/meeting_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/meeting.dart';
import 'package:frontend/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  ThemeMode _themeMode = ThemeMode.system;
  LatLng? selectedMapLatLng;
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
            title: Text(AppLocalizations.of(context)!.plsSelectImage,
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
                        Text(AppLocalizations.of(context)!.fromGallery,
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
                        Text(AppLocalizations.of(context)!.fromCamera,
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
  void initState() {
    super.initState();
    // Set initial values for the text controllers
    meetingController.titleController.text = widget.meeting.title;
    meetingController.descriptionController.text = widget.meeting.description;
    meetingController.feeController.text =
        widget.meeting.registration_fee.toString();
    meetingController.locationController.text = widget.meeting.location;
    meetingController.dateController.text = widget.meeting.date;
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
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppLocalizations.of(context)!.editMeeting,
              style: TextStyle(color: ButtonBlack)),
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
                      color: _themeMode == ThemeMode.dark
                          ? Colors.grey[800]
                          : Colors.grey[300],
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
                      errorText: _validatetitle
                          ? AppLocalizations.of(context)!.notEmpty
                          : null,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: meetingController.feeController,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Background),
                            ),
                            errorText: _validatefee
                                ? AppLocalizations.of(context)!.notEmpty
                                : null,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Background),
                            ),
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
                            errorText: _validatelocation
                                ? AppLocalizations.of(context)!.notEmpty
                                : null,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Background),
                            ),
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
                        maxLength: 40,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Text("Current location",
                    style: TextStyle(
                        color: _themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Container(
                  width: 350,
                  height: 200,
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(widget.meeting.lat, widget.meeting.lng),
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
                            point:
                                LatLng(widget.meeting.lat, widget.meeting.lng),
                            builder: (ctx) => Container(
                              child: Icon(Icons.location_on, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(
                          "Change the location",
                          style: TextStyle(
                            color: _themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Background,
                        ),
                        onPressed: () async {
                          var geoPoint = await showSimplePickerLocation(
                            context: context,
                            isDismissible: true,
                            title: "Select location",
                            textConfirmPicker: "Pick",
                            initCurrentUserPosition: true,
                            initZoom: 12,
                          );

                          if (geoPoint != null) {
                            setState(() {
                              selectedMapLatLng =
                                  LatLng(geoPoint.latitude, geoPoint.longitude);
                              meetingController.latController.text =
                                  geoPoint.latitude.toString();
                              meetingController.lngController.text =
                                  geoPoint.longitude.toString();
                            });
                          }

                          Fluttertoast.showToast(
                            msg: "Selected location: $selectedMapLatLng",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                          );
                        },
                      ),
                    ),
                    if (selectedMapLatLng != null)
                      Container(
                        width: 200,
                        height: 200,
                        child: FlutterMap(
                          options: MapOptions(
                            center: selectedMapLatLng!,
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
                                if (selectedMapLatLng != null)
                                  Marker(
                                    width: 40.0,
                                    height: 40.0,
                                    point: selectedMapLatLng!,
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
                        lastDate: DateTime(2028),
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
                              dialogBackgroundColor:
                                  _themeMode == ThemeMode.dark
                                      ? Colors.grey[900]
                                      : Colors.white,
                              buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary,
                              ),
                            ),
                            child: child!,
                          );
                        });
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
                      errorText: _validatedate
                          ? AppLocalizations.of(context)!.notEmpty
                          : null,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
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
                ),
                TextField(
                  controller: meetingController.descriptionController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      errorText: _validatedesc
                          ? AppLocalizations.of(context)!.notEmpty
                          : null,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      counterStyle: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                  style: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black),
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
                      if (meetingController.latController.text.isEmpty &&
                          meetingController.lngController.text.isEmpty) {
                        meetingController.latController.text =
                            widget.meeting.lat.toString();
                        meetingController.lngController.text =
                            widget.meeting.lng.toString();
                      }
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
                        lat: parseDouble(meetingController.latController.text),
                        lng: parseDouble(meetingController.lngController.text),
                      );
                      change = "";
                      currentPhoto = "";
                      if (meetingController.latController.text !=
                              widget.meeting.lat.toString() &&
                          meetingController.lngController.text !=
                              widget.meeting.lng.toString()) {
                        Fluttertoast.showToast(
                          msg:
                              "Location will be correctly displayed after the page is refreshed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                        );
                      }
                      // Pass the updated blog as a separate parameter
                      Navigator.pop(context, updatedMeeting);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.buttonSubmit,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ]),
            ),
          ]),
        ));
  }

  double parseDouble(String value) {
    return double.tryParse(value) ?? 0.0; // Returns 0.0 if parsing fails
  }
}
