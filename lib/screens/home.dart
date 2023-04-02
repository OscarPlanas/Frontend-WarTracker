import 'package:flutter/material.dart';
import 'package:frontend/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/constants.dart';
import 'package:localstorage/localstorage.dart';
//import 'package:frontend/models/blogplaceholder.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/blog.dart';
import 'package:frontend/controllers/blog_controller.dart';

//import 'package:frontend/screens/register.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final BlogController blogController = Get.put(BlogController());
  //final Future<List<Blog>> blogs = BlogController().getBlogs();
  Future<List<Blog>> blogsFuture = BlogController().getBlogs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title:
            const Text(('Latest News'), style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
        actions: [
          TextButton(
              onPressed: () async {
                final SharedPreferences? prefs = await _prefs;
                prefs?.clear();
                // setItem('token', null);
                Get.offAll(WelcomeScreen());
              },
              child: Text(
                'logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      drawer: NavigationDrawer(),
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
                        leading:
                            Image.network("https://picsum.photos/250?image=9"),
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
          //itemCount: blog.length,
          /*itemBuilder: (context, index) {
            //Blog blog = blogController[index];
            return Card(
              child: ListTile(
                
                title: Text(blogs.),
                subtitle: Text(blogs.shortoverview),
                leading: Image.network(blog.image),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(BlogScreen(blog));
                },
              ),
            );*/

          /*child: ListView(
          children: [
            //Text('Welcome home'),
            TextButton(
                onPressed: () async {
                  final SharedPreferences? prefs = await _prefs;
                  print(prefs?.get('token'));
                },
                child: Text('print token'))
          ],
        ),*/
          // }),
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) => Drawer(
          child: SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          buildMenuItems(context),
        ],
      )));

  Widget buildHeader(BuildContext context) => Container(
        color: Background,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage('assets/images/logoWelcome.png'),
            ),
            SizedBox(height: 8),
            Text('PlaceholderProfile',
                style: TextStyle(color: ButtonBlack, fontSize: 22)),
            Text('PlaceholderEmail',
                style: TextStyle(color: ButtonBlack, fontSize: 14)),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          //runSpacing: 2,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => Get.offAll(HomeScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: () async {
                final SharedPreferences? prefs = await _prefs;
                prefs?.clear();
                Get.offAll(WelcomeScreen());
              },
            ),
            const Divider(color: Colors.black54),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => Get.offAll(HomeScreen()),
            ),
          ],
        ),
      );
}
