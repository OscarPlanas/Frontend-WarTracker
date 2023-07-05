import 'package:flutter/material.dart';
import 'package:frontend/data/data.dart';
import 'package:get/get.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/screens/blog.dart';
import 'package:frontend/controllers/blog_controller.dart';
import 'package:frontend/sidebar.dart';
import 'package:frontend/controllers/user_controller.dart';
import 'package:frontend/screens/create_blog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Blog>> blogsFuture = BlogController().getBlogs();
  Future user = UserController().getUser();
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
      //drawer: NavigationDrawer(),
      body: Center(
        child: FutureBuilder<List<Blog>>(
          future: blogsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Blog blog = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        title: Text(blog.title),
                        subtitle: Text(blog.description),
                        leading: Image.network(blog.imageUrl),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(BlogScreen(blog));
                        },
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
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
