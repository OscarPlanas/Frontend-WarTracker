import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/blog.dart';
import 'package:frontend/screens/home.dart';
import 'package:get/get.dart';
import 'package:frontend/controllers/blog_controller.dart';

class CreateBlog extends StatefulWidget {
  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  //final String authorName, title, desc;
  //final _formKey = GlobalKey<FormState>();
  // declare a variable to keep track of the input text
  // String _title = '';
  // String _desc = '';
  // String _body = '';
  BlogController blogController = Get.put(BlogController());

  var _title = TextEditingController();
  var _desc = TextEditingController();
  var _body = TextEditingController();
  bool _validatetitle = false;
  bool _validatedesc = false;
  bool _validatebody = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.offAll(HomeScreen()),
          ),
          title: Text("Create a blog", style: TextStyle(color: ButtonBlack)),
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
                      blogController.contentController.text.isNotEmpty)
                    {
                      await blogController.createBlog(),
                      Get.offAll(HomeScreen()),
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

  /*void _submit() {
    // if there is no error text
    if (_errorText == null) {
      // notify the parent widget via the onSubmit callback
      widget.onSubmit(_controller.value.text);
    }
  }*/
}
