import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/blog_controller.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/screens/blog.dart';
import 'package:frontend/screens/home.dart';
import 'package:get/get.dart';

class EditBlog extends StatefulWidget {
  final Blog blog;
  EditBlog(this.blog);
  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  BlogController blogController = Get.put(BlogController());

  @override
  void initState() {
    super.initState();

    // Set initial values for the text controllers
    blogController.titleController.text = widget.blog.title;
    blogController.descriptionController.text = widget.blog.description;
    blogController.contentController.text = widget.blog.body_text;
    print("title: " + blogController.titleController.text);
    print("description: " + blogController.descriptionController.text);
    print("body: " + blogController.contentController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.off(BlogScreen(widget.blog)),
          ),
          title: Text("Edit your blog", style: TextStyle(color: ButtonBlack)),
          iconTheme: IconThemeData(color: ButtonBlack),
          backgroundColor: Background,
        ),
        body: Container(
          child: ListView(children: <Widget>[
            SizedBox(height: 10),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6)),
                width: MediaQuery.of(context).size.width,
                child: Icon(Icons.add_a_photo, color: Colors.black)),
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
                    blogController.editBlog(widget.blog.id);
                    setState(() {
                      // Validation code...

                      // Pass the updated blog as a result
                      Get.offAll(HomeScreen());
                    });
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

  /*void _submit() {
    // if there is no error text
    if (_errorText == null) {
      // notify the parent widget via the onSubmit callback
      widget.onSubmit(_controller.value.text);
    }
  }*/
}
