import 'dart:async';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/blog_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/screens/home.dart';
import 'package:image_picker/image_picker.dart';

class CreateBlog extends StatefulWidget {
  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  BlogController blogController = BlogController();

  bool _validatetitle = false;
  bool _validatedesc = false;
  bool _validatebody = false;
  bool isloading = false;

  ImageProvider? selectedImage; // Store the selected image

  final cloudinary = CloudinaryPublic("dagbarc6g", 'WarTracker', cache: false);

  XFile? image;

  final ImagePicker picker = ImagePicker();

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
  Widget build(BuildContext context) {
    if (change != "") {
      currentPhoto = change;
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    }),
                  )),
          title: Text("Create a blog", style: TextStyle(color: ButtonBlack)),
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
                color: Colors.grey[300],
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
                  ? Icon(Icons.add_a_photo, color: Colors.black)
                  : null,
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
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Background),
                    ),
                    hintText: "Write the title of your blog",
                    errorText: _validatetitle ? 'Can\'t Be Empty' : null,
                    counterStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold)),
                maxLength: 30,
              ),
              TextField(
                controller: blogController.descriptionController,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Background),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Background),
                    ),
                    hintText: "Write a description of your blog",
                    errorText: _validatedesc ? 'Can\'t Be Empty' : null,
                    counterStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold)),
                maxLength: 50,
              ),
              TextField(
                controller: blogController.contentController,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Background),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Background),
                    ),
                    hintText: "Write your blog",
                    errorText: _validatebody ? 'Can\'t Be Empty' : null,
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
                onPressed: () async => {
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
                  }),
                  if (blogController.titleController.text.isNotEmpty &&
                      blogController.descriptionController.text.isNotEmpty &&
                      blogController.contentController.text.isNotEmpty &&
                      selectedImage != null)
                    {
                      await blogController.createBlog(currentPhoto),
                      change = "",
                      currentPhoto = "",
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }),
                      )
                    }
                  else if (selectedImage == null)
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please select an image.'),
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
