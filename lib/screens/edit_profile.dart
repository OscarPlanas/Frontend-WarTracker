import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/user_controller.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  final User user;

  EditProfile(this.user);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserController userController = UserController();
  bool _validatename = false;
  bool _validateusername = false;

  bool _validatepassword = false;

  bool isPasswordTextField = true;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userController.nameController.text = widget.user.name;
    userController.usernameController.text = widget.user.username;
    userController.emailController.text = widget.user.email;
    userController.passwordController.text = widget.user.password;
    userController.repeatPasswordController.text = widget.user.password;
    userController.aboutController.text = widget.user.about;
  }

  final double coverHeight = 280;
  final double profileHeight = 144;

  bool isObscurePassword = true;
  bool isPasswordChanged = false;

  bool isloading = false;
  File? imageFile;

  final cloudinary = CloudinaryPublic("dagbarc6g", 'WarTracker', cache: false);

  XFile? image;
  final ImagePicker picker = ImagePicker();
  ImageProvider? selectedImage; // Store the selected cover image
  ImageProvider? selectedAvatarImage; // Store the selected avatar image

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
        selectedAvatarImage = NetworkImage(response.secureUrl);
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
        selectedAvatarImage = NetworkImage(response.secureUrl);
      });
      currentPhoto = response.secureUrl; // Set the currentPhoto value
      change = response.secureUrl;
    } catch (e) {
      print(e);
    }
  }

  Future uploadCoverImage() async {
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
      currentBackgroundPhoto = response.secureUrl; // Set the currentPhoto value
      changeBackground = response.secureUrl;
    } catch (e) {
      print(e);
    }
  }

  Future uploadCoverImage2() async {
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
      currentBackgroundPhoto = response.secureUrl; // Set the currentPhoto value
      changeBackground = response.secureUrl;
    } catch (e) {
      print(e);
    }
  }

  //show popup dialog
  void myAlert(bool isAvatarImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text('Please choose media to select'),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (isAvatarImage) {
                      uploadImage2(); // Upload avatar image
                    } else {
                      uploadCoverImage2(); // Upload cover image
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      Text('From Gallery'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (isAvatarImage) {
                      uploadImage(); // Upload avatar image
                    } else {
                      uploadCoverImage(); // Upload cover image
                    }
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
      },
    );
  }

  void passwordChange() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String currentPassword = '';
        String newPassword = '';

        // Create empty TextEditingController instances

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text('Change Password'),
          content: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                TextField(
                  controller: currentPasswordController,
                  onChanged: (value) {
                    currentPassword = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    errorText:
                        _validatepassword ? 'Enter a valid password' : null,
                  ),
                  obscureText: isObscurePassword,
                ),
                TextField(
                  controller: newPasswordController,
                  onChanged: (value) {
                    newPassword = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    errorText:
                        _validatepassword ? 'Enter a valid password' : null,
                  ),
                  obscureText: isObscurePassword,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Validate the entered passwords
                  _validatepassword =
                      currentPassword.isEmpty || newPassword.isEmpty;
                  // If passwords are valid, perform the password change logic
                  if (!_validatepassword) {
                    // Password changed, set the flag to true
                    isPasswordChanged = true;
                  }
                });

                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
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
              Text("Edit your profile", style: TextStyle(color: ButtonBlack)),
          iconTheme: IconThemeData(color: ButtonBlack),
          backgroundColor: Background,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                buildTop(),
                SizedBox(height: 30),
                Text("Name",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: TextField(
                    controller: userController.nameController,
                    decoration: InputDecoration(
                      errorText: _validatename ? 'Can\'t Be Empty' : null,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Text("Username",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: TextField(
                    controller: userController.usernameController,
                    decoration: InputDecoration(
                      errorText: _validateusername ? 'Can\'t Be Empty' : null,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Text("Email",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: TextField(
                    controller: userController.emailController,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    readOnly: true,
                    enableInteractiveSelection: false,
                  ),
                ),
                Text("Password",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: "Password"),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            ),
                          ),
                          obscureText: true,
                          readOnly: true,
                          enableInteractiveSelection: false,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          passwordChange();
                        },
                        child: Text("Change"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Background,
                          foregroundColor: ButtonBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text("About",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                buildTextField(
                    userController.aboutController, widget.user.about, false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: Text(
                        "CANCEL",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        /*setState(() {
                      userController.nameController.text.isEmpty
                          ? _validatename = true
                          : _validatename = false;
                      userController.usernameController.text.isEmpty
                          ? _validateusername = true
                          : _validateusername = false;
                      userController.emailController.text.isEmpty
                          ? _validateemail = true
                          : _validateemail = false;
                      userController.passwordController.text.isEmpty
                          ? _validatepassword = true
                          : _validatepassword = false;

                
                    });*/
                        /*if (currentPhoto == "" || currentPhoto == " ") {
                      currentPhoto = widget.blog.imageUrl;
                    }*/
                        /*if (blogController.titleController.text.isNotEmpty &&
                        blogController.descriptionController.text.isNotEmpty &&
                        blogController.contentController.text.isNotEmpty) {*/
                        if ((currentPhoto == "" || currentPhoto == " ") &&
                            (currentBackgroundPhoto == "" ||
                                currentBackgroundPhoto == " ")) {
                          currentPhoto = widget.user.imageUrl;
                          currentBackgroundPhoto =
                              widget.user.backgroundImageUrl;
                        } /*userController.changePassword(
                    currentPasswordController.text,
                    newPasswordController.text,
                  );*/
                        int success = await userController.editUser(
                            widget.user.id,
                            currentPhoto,
                            currentBackgroundPhoto,
                            currentPasswordController.text,
                            newPasswordController.text,
                            isPasswordChanged);

                        if (success == 0) {
                          User updatedUser = User(
                            id: widget.user.id,
                            name: userController.nameController.text,
                            username: userController.usernameController.text,
                            email: widget.user.email,
                            password: widget.user.password,
                            imageUrl: currentPhoto,
                            backgroundImageUrl: currentBackgroundPhoto,
                            about: userController.aboutController.text,
                          );
                          change = "";
                          currentPhoto = "";
                          currentBackgroundPhoto = "";
                          changeBackground = "";
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false,
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(updatedUser)),
                          );
                          Fluttertoast.showToast(
                            msg: 'Profile updated successfully',
                            toastLength: Toast.LENGTH_LONG,
                          );
                          userController.nameController.clear();
                          userController.usernameController.clear();
                          userController.passwordController.clear();
                          userController.repeatPasswordController.clear();
                        } else if (success == 1) {
                          openDialog("Wrong password");
                        } else if (success == 2) {
                          openDialog("Username already exists");
                        } else if (success == 3) {
                          openDialog("An error occurred");
                        }
                      },
                      child: Text("SAVE",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: ButtonBlack)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Background,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  Widget buildTextField(TextEditingController labelText, String placeholder,
      bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: labelText,
        decoration: InputDecoration(
          errorText: _validatename ? 'Can\'t Be Empty' : null,
        ),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildAvatarImage(),
        ),
      ],
    );
  }

  Widget buildAvatarImage() {
    return Stack(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            border: Border.all(width: 4, color: Colors.white),
            boxShadow: [
              BoxShadow(
                spreadRadius: 2,
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: selectedAvatarImage != null
                  ? selectedAvatarImage!
                  : NetworkImage(widget.user.imageUrl),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 4,
                color: Colors.white,
              ),
              color: Background,
            ),
            child: Align(
              alignment: Alignment.center,
              child: FractionalTranslation(
                translation: Offset(-0.1, -0.1),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: ButtonBlack,
                  ),
                  onPressed: () {
                    myAlert(true); // Pass 'true' for avatar image
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCoverImage() {
    return Stack(
      children: [
        Image(
          image: selectedImage != null
              ? selectedImage!
              : NetworkImage(widget.user.backgroundImageUrl),
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              myAlert(false); // Pass 'false' for cover image
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 4, color: Colors.white),
                color: Background,
              ),
              child: Icon(
                Icons.edit,
                color: ButtonBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future openDialog(String text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color.fromARGB(255, 230, 241, 248),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("WarTracker", style: TextStyle(fontSize: 17)),
          content: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: submit,
            ),
          ],
        ),
      );
  void submit() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
