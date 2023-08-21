import 'package:flutter/material.dart';
import 'package:frontend/controllers/user_controller.dart';
import 'package:frontend/screens/blog.dart';
import 'package:frontend/screens/edit_profile.dart';
import 'package:frontend/screens/meeting.dart';
import 'package:frontend/sidebar.dart';
import 'package:frontend/components/numbers_widget.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/data/data.dart';
import 'package:get/get.dart';
import 'package:frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/meeting.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  final User user;

  Profile(this.user);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserController userController = Get.put(UserController());

  final double coverHeight = 280;
  final double profileHeight = 144;

  int followersCount = 0;

  bool showMeetings = false;
  bool showBlogs = false;
  bool isUser = false;
  bool _flag2 = false;

  List<Meeting> meetingsFollowed = [];

  List<Meeting> meetings = [];

  List<Blog> blogs = [];

  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    checkIsUser();
    fetchMeetingsFollowed();
    fetchBlogsFollowed();
    isFollowed();
    fetchFollowersCount(); // Fetch the initial count of followers
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

  Future<void> checkIsUser() async {
    var url = Uri.parse('http://10.0.2.2:5432/api/users/' + widget.user.id);
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      currentUser.username == data['username'] ? isUser = true : isUser = false;
    });
  }

  Future<void> fetchMeetingsFollowed() async {
    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/users/' + widget.user.id));
    var jsonData = json.decode(data.body);
    List<dynamic> meetingsFollowedData = jsonData['meetingsFollowed'];

    var futures = meetingsFollowedData.map((meetingData) async {
      var organizerId = meetingData['organizer'];

      UserController userController = Get.put(UserController());
      User user = await userController.getOneUser(organizerId);

      Map<String, dynamic> organizerData = user.toMap();

      return Meeting(
        id: meetingData['_id'],
        title: meetingData['title'],
        imageUrl: meetingData['imageUrl'],
        description: meetingData['description'],
        organizer: organizerData,
        date: meetingData['date'],
        location: meetingData['location'],
        participants: meetingData['participants'],
        registration_fee: meetingData['registration_fee'],
        lat: meetingData['lat'],
        lng: meetingData['lng'],
      );
    });

    meetings = await Future.wait(futures);
  }

  Future<void> fetchBlogsFollowed() async {
    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/users/' + widget.user.id));
    var jsonData = json.decode(data.body);
    print(jsonData);

    List<dynamic> blogsFollowedData = jsonData['blogsLiked'];
    print("blogsFollowedData: $blogsFollowedData");

    var futures = blogsFollowedData.map((blogData) async {
      print("blogData: $blogData");
      var authorId = blogData['author'];
      print("authorId: $authorId");

      UserController userController = Get.put(UserController());
      User user = await userController.getOneUser(authorId);

      Map<String, dynamic> authorData = user.toMap();
      print("authorData: $authorData");

      return Blog(
        id: blogData['_id'],
        title: blogData['title'],
        imageUrl: blogData['imageUrl'],
        description: blogData['description'],
        body_text: blogData['body_text'],
        author: authorData,
        date: blogData['date'],
        usersLiked: blogData['usersLiked'],
      );
    });
    blogs = await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile,
            style: TextStyle(color: ButtonBlack)),
        iconTheme: IconThemeData(color: ButtonBlack),
        backgroundColor: Background,
      ),
      drawer: Sidebar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isUser && currentUser.id == widget.user.id)
            FloatingActionButton(
              child: Icon(Icons.edit, color: ButtonBlack),
              backgroundColor: Background,
              onPressed: () async {
                final updatedUser = await Get.to(EditProfile(widget.user));

                if (updatedUser != null) {
                  setState(() {
                    // Update the user object with the new data
                    widget.user.name = updatedUser.name;
                    widget.user.username = updatedUser.username;
                    widget.user.email = updatedUser.email;
                    widget.user.imageUrl = updatedUser.imageUrl;
                    widget.user.backgroundImageUrl =
                        updatedUser.backgroundImageUrl;
                  });
                }
              },
            ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          widget.user.username,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color:
                  _themeMode == ThemeMode.dark ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 2),
        Text(
          widget.user.name,
          style: TextStyle(
            fontSize: 22,
            color: _themeMode == ThemeMode.dark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.user.date,
          style: TextStyle(
            fontSize: 20,
            color: _themeMode == ThemeMode.dark
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.user.email,
          style: TextStyle(
            fontSize: 20,
            color: _themeMode == ThemeMode.dark
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 16),
        Divider(
            color: _themeMode == ThemeMode.dark
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.3)),
        const SizedBox(height: 16),
        NumbersWidget(widget.user, followersCount, _themeMode),
        Divider(
            color: _themeMode == ThemeMode.dark
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.3)),
        const SizedBox(height: 16),
        buildAbout(),
        const SizedBox(height: 32),
        buildMeetingsDropdown(),
        const SizedBox(height: 16),
        buildBlogsDropdown(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget buildAbout() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              AppLocalizations.of(context)!.about,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color:
                    _themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.user.about,
              style: TextStyle(
                fontSize: 18,
                height: 1.4,
                color: _themeMode == ThemeMode.dark
                    ? Colors.white.withOpacity(0.9)
                    : Colors.black.withOpacity(0.9),
              ),
            ),
          ),
        ],
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
          child: buildProfileImage(),
        ),
        Positioned(
          top: coverHeight + 24, // Adjust the vertical position as needed
          right: 16, // Adjust the horizontal position as needed
          child: (!isUser && currentUser.id != widget.user.id)
              ? buildFollowButton()
              : SizedBox(), // Render an empty SizedBox when the condition is false
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.network(widget.user.backgroundImageUrl, fit: BoxFit.cover),
        width: double.infinity,
        height: coverHeight,
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(widget.user.imageUrl),
      );

  Widget buildMeetingsDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                showMeetings =
                    !showMeetings; // Update the variable within setState
              });
            },
            child: Row(
              children: [
                Icon(
                  showMeetings ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: _themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  showMeetings
                      ? AppLocalizations.of(context)!.hideMeetings
                      : AppLocalizations.of(context)!.meetingsProfileMeeting,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (showMeetings) ...buildMeetingList(),
        ],
      ),
    );
  }

  Widget buildFollowButton() {
    // Implement your follow button UI here
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _flag2 ? Background : Colors.red,
        foregroundColor: ButtonBlack,
      ),
      onPressed: () => {
        setState(() {
          _flag2 = !_flag2;
        }),
        if (_flag2)
          {
            followersCount--,
            userController.unfollowUser(widget.user.id),
          }
        else
          {
            followersCount++,
            userController.followUser(widget.user.id),
          }
      },
      child: Text(_flag2
          ? AppLocalizations.of(context)!.follow
          : AppLocalizations.of(context)!.unfollow),
    );
  }

  List<Widget> buildMeetingList() {
    List<Widget> meetingRows = [];

    for (int i = 0; i < meetings.length; i += 2) {
      if (i + 1 < meetings.length) {
        // Create a row with two meetings
        var meetingRow = Row(
          children: [
            buildMeetingCard(i),
            SizedBox(width: 16),
            buildMeetingCard(i + 1),
          ],
        );
        meetingRows.add(meetingRow);
      } else {
        // Handle the case when there's only one meeting left
        var meetingRow = Row(
          children: [
            buildMeetingCard(i),
          ],
        );
        meetingRows.add(meetingRow);
      }
    }

    return meetingRows;
  }

  Widget buildMeetingCard(int index) {
    final meeting = meetings[index];

    return Expanded(
      child: GestureDetector(
        onTap: () {
          navigateToMeetingScreen(meeting);
        },
        child: Card(
          color: _themeMode == ThemeMode.dark ? Colors.grey[800] : Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(meeting.imageUrl),
            ),
            title: Text(meeting.title,
                style: _themeMode == ThemeMode.dark
                    ? TextStyle(color: Colors.white)
                    : TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }

  void navigateToMeetingScreen(Meeting meeting) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeetingScreen(meeting),
      ),
    );
  }

  Widget buildBlogsDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                showBlogs = !showBlogs;
              });
            },
            child: Row(
              children: [
                Icon(showBlogs ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: _themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black),
                SizedBox(width: 8),
                Text(
                  showBlogs
                      ? AppLocalizations.of(context)!.hideBlogs
                      : AppLocalizations.of(context)!.meetingsProfile,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black),
                ),
              ],
            ),
          ),
          if (showBlogs) ...buildBlogList(),
        ],
      ),
    );
  }

  List<Widget> buildBlogList() {
    List<Widget> blogRows = [];

    for (int i = 0; i < blogs.length; i += 2) {
      if (i + 1 < blogs.length) {
        // Create a row with two meetings
        var blogRow = Row(
          children: [
            buildBlogCard(i),
            SizedBox(width: 16),
            buildBlogCard(i + 1),
          ],
        );
        blogRows.add(blogRow);
      } else {
        // Handle the case when there's only one meeting left
        var blogRow = Row(
          children: [
            buildBlogCard(i),
          ],
        );
        blogRows.add(blogRow);
      }
    }

    return blogRows;
  }

  Widget buildBlogCard(int index) {
    final blog = blogs[index];

    return Expanded(
      child: GestureDetector(
        onTap: () {
          navigateToBlogScreen(blog);
        },
        child: Card(
          color: _themeMode == ThemeMode.dark ? Colors.grey[800] : Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(blog.imageUrl),
            ),
            title: Text(blog.title,
                style: _themeMode == ThemeMode.dark
                    ? TextStyle(color: Colors.white)
                    : TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }

  void navigateToBlogScreen(Blog blog) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogScreen(blog),
      ),
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

  Future<void> isFollowed() async {
    UserController userController = await Get.put(UserController());

    bool _isFollowed = await userController.userIsFollowed(widget.user.id);

    if (_isFollowed == true) {
      setState(() {
        _flag2 = false;
        //listParticipants += 1;
      });
    } else {
      setState(() {
        _flag2 = true;
        //listParticipants -= 1;
      });
    }
  }

  Future<void> fetchFollowersCount() async {
    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/users/' + widget.user.id));
    var jsonData = json.decode(data.body);
    int count = jsonData['followers'].length;
    setState(() {
      followersCount = count;
    });
  }
}
