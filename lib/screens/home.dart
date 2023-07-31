import 'package:flutter/material.dart';
import 'package:frontend/components/customListTile.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/controllers/blog_controller.dart';
import 'package:frontend/controllers/user_controller.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/screens/create_blog.dart';
import 'package:frontend/sidebar.dart';
import 'package:get/get.dart';
import 'package:frontend/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Blog>> blogsFuture = BlogController().getBlogs();
  Future user = UserController().getUser();

  ThemeMode _themeMode = ThemeMode.system; // Initialize with system mode

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title:
            const Text(('Latest News'), style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
      ),
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      body: FutureBuilder<List<Blog>>(
        future: blogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Blog blog = snapshot.data![index];
                return customListTile(blog, context, _themeMode);
              },
            );
          } else {
            return Center(child: Text('No blogs found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAll(CreateBlog());
        },
        child: Text("Create blog",
            style: TextStyle(color: ButtonBlack, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        backgroundColor: Background,
      ),
    );
  }
}
