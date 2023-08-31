import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:war_tracker/constants.dart';
import 'package:war_tracker/controllers/blog_controller.dart';
import 'package:war_tracker/data/data.dart';
import 'package:war_tracker/models/blog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:war_tracker/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:war_tracker/screens/home.dart';

class EditBlog extends StatefulWidget {
  final Blog blog;

  EditBlog(this.blog) : selectedImage = NetworkImage(blog.imageUrl);
  final ImageProvider selectedImage;

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  BlogController blogController = BlogController();
  bool _validatetitle = false;
  bool _validatedesc = false;
  bool _validatebody = false;

  bool isloading = false;

  File? imageFile;

  final cloudinary = CloudinaryPublic("dagbarc6g", 'WarTracker', cache: false);

  XFile? image;
  final ImagePicker picker = ImagePicker();
  ImageProvider? selectedImage; // Store the selected image
  ThemeMode _themeMode = ThemeMode.system; // Initialize with system mode
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
    blogController.titleController.text = widget.blog.title;
    blogController.descriptionController.text = widget.blog.description;
    blogController.contentController.text = widget.blog.body_text;
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
          title: Text(AppLocalizations.of(context)!.editBlog,
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
                          : widget.blog.imageUrl != ""
                              ? DecorationImage(
                                  image: NetworkImage(widget.blog.imageUrl),
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
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: <Widget>[
                TextField(
                  controller: blogController.titleController,
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
                TextField(
                  controller: blogController.descriptionController,
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
                        : Colors.black,
                  ),
                  maxLength: 50,
                ),
                TextField(
                  controller: blogController.contentController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Background),
                      ),
                      errorText: _validatebody
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
                  maxLength: 1000,
                  maxLines: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Background,
                  ),
                  onPressed: () async {
                    setState(() {
                      blogController.titleController.text.isEmpty
                          ? _validatetitle = true
                          : _validatetitle = false;
                      blogController.descriptionController.text.isEmpty
                          ? _validatedesc = true
                          : _validatedesc = false;
                      blogController.contentController.text.isEmpty
                          ? _validatebody = true
                          : _validatebody = false;
                    });
                    if (currentPhoto == "" || currentPhoto == " ") {
                      currentPhoto = widget.blog.imageUrl;
                    }
                    if (blogController.titleController.text.isNotEmpty &&
                        blogController.descriptionController.text.isNotEmpty &&
                        blogController.contentController.text.isNotEmpty) {
                      blogController.editBlog(widget.blog.id, currentPhoto);
                      // Create the updated blog object
                      Blog updatedBlog = Blog(
                        author: widget.blog.author,
                        id: widget.blog.id,
                        title: blogController.titleController.text,
                        description: blogController.descriptionController.text,
                        body_text: blogController.contentController.text,
                        date: widget.blog.date,
                        imageUrl: currentPhoto,
                        usersLiked: widget.blog.usersLiked,
                      );
                      change = "";
                      currentPhoto = "";

                      // Pass the updated blog as a separate parameter
                      Navigator.pop(context, updatedBlog);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.buttonSubmit,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 10),
                //Eliminate blog button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: _themeMode == ThemeMode.dark
                                ? Color.fromARGB(255, 32, 30, 30)
                                : Colors.white,
                            title: Text(
                                AppLocalizations.of(context)!.deleteBlog,
                                style: TextStyle(
                                    color: _themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black)),
                            content: Text(
                              AppLocalizations.of(context)!.confirmDeleteBlog,
                              style: TextStyle(
                                  color: _themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _themeMode == ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black)),
                              ),
                              TextButton(
                                onPressed: () {
                                  blogController.deleteBlog(widget.blog.id);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return HomeScreen();
                                    },
                                  ));
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.buttonYes,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _themeMode == ThemeMode.dark
                                            ? Colors.white
                                            : Colors.black)),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.deleteBlog,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ]),
            ),
          ]),
        ));
  }
}
