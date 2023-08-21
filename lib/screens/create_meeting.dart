import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/meeting_controller.dart';
import 'package:frontend/main_state.dart';
import 'package:frontend/screens/tournaments.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:frontend/data/data.dart';
import 'package:dio/dio.dart';
import 'package:frontend/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart' as map;
import 'package:latlong2/latlong.dart';

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

  MainStateController controller = MainStateController();

  TextEditingController textController = TextEditingController();

  LatLng? selectedMapLatLng;

  final StreamController<LatLng> _mapCenterStreamController =
      StreamController<LatLng>.broadcast();

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
  void dispose() {
    _mapCenterStreamController.close();
    super.dispose();
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
          title: Text(AppLocalizations.of(context)!.createMeeting,
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
                      hintText:
                          AppLocalizations.of(context)!.createTitleMeeting,
                      hintStyle: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.grey[800]),
                      errorText: _validatetitle
                          ? AppLocalizations.of(context)!.notEmpty
                          : null,
                      counterStyle: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Color.fromRGBO(255, 255, 255, 1)
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 56,
                        padding: EdgeInsets.zero,
                        child: TextField(
                          controller: meetingController.feeController,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Background),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Background),
                            ),
                            hintText: AppLocalizations.of(context)!.createFee,
                            hintStyle: TextStyle(
                                color: _themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.grey[800]),
                            errorText: _validatefee
                                ? AppLocalizations.of(context)!.notEmpty
                                : null,
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
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 17.5,
                        padding: EdgeInsets.zero,
                        child: TextField(
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
                              },
                            );

                            if (pickedDate != null) {
                              setState(() {
                                // Store the selected date
                                selectedDate = pickedDate;
                                // Update the text field with the selected date
                                meetingController.dateController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDate);
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
                            hintText: AppLocalizations.of(context)!.createDate,
                            hintStyle: TextStyle(
                                color: _themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.grey[800]),
                            errorText: _validatedate
                                ? AppLocalizations.of(context)!.notEmpty
                                : null,
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
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                TextField(
                  controller: meetingController.locationController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      hintText: AppLocalizations.of(context)!.cityLocation,
                      hintStyle: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.grey[800]),
                      errorText: _validatelocation
                          ? AppLocalizations.of(context)!.notEmpty
                          : null,
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
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(
                          AppLocalizations.of(context)!.selectLocation,
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
                            title: AppLocalizations.of(context)!.selectLocation,
                            textConfirmPicker:
                                AppLocalizations.of(context)!.save,
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
                        child: map.FlutterMap(
                          options: map.MapOptions(
                            center: selectedMapLatLng!,
                            zoom: 13.0,
                          ),
                          children: [
                            map.TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            map.MarkerLayer(
                              markers: [
                                if (selectedMapLatLng != null)
                                  map.Marker(
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
                  controller: meetingController.descriptionController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      hintText: AppLocalizations.of(context)!
                          .createMeetingDescription,
                      hintStyle: TextStyle(
                          color: _themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.grey[800]),
                      errorText: _validatedesc
                          ? AppLocalizations.of(context)!.notEmpty
                          : null,
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
                    if (meetingController.titleController.text.isEmpty ||
                        meetingController.descriptionController.text.isEmpty ||
                        meetingController.feeController.text.isEmpty ||
                        meetingController.locationController.text.isEmpty ||
                        meetingController.dateController.text.isEmpty ||
                        selectedImage == null &&
                            meetingController.latController.text.isEmpty &&
                            meetingController.lngController.text.isEmpty)
                      {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.plsFill,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                        ),
                      }
                    else if (meetingController.latController.text.isEmpty &&
                        meetingController.lngController.text.isEmpty)
                      {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)!.plsLocation,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                        ),
                      }
                    else
                      {
                        // All fields are filled, proceed with the submit action
                        await meetingController.createMeeting(currentPhoto),
                        change = "",
                        currentPhoto = "",
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TournamentScreen();
                        })),
                        Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!.meetingCreated,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Background,
                            textColor: ButtonBlack,
                            fontSize: 16.0)
                      },
                  },
                  child: Text(
                    AppLocalizations.of(context)!.buttonSubmit,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ]),
            )
          ]),
        ));
  }
}
