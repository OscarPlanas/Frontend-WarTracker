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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Blog>> blogsFuture = BlogController().getBlogs();
  Future user = UserController().getUser();

  ThemeMode _themeMode = ThemeMode.system; // Initialize with system mode

  String _selectedFilter = 'Date'; // Default filter option is 'Date'
  String _selectedDirection = 'Newer'; // Default direction option is 'Newer'
  Future<List<Blog>>? _filteredBlogsFuture; // Updated Future based on filter
  List<Blog> _sortedBlogs = []; // Store the sorted blogs
  Map<String, String> _filterTranslations = {};
  Map<String, String> _directionTranslations = {};
  String _searchText = "";
  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _filteredBlogsFuture = blogsFuture; // Initialize with default value
    _selectedDirection = 'Newer';
    _updateBlogsFuture(); // Initialize sorting
  }

  void _loadThemeMode() async {
    // Retrieve the saved theme mode from SharedPreferences
    ThemeMode savedThemeMode = await ThemeHelper.getThemeMode();
    print(savedThemeMode);
    setState(() {
      _themeMode = savedThemeMode;
      _filterTranslations = {
        'Date': AppLocalizations.of(context)!.date,
        'Popularity': AppLocalizations.of(context)!.popularity,
      };
      _directionTranslations = {
        'Newer': AppLocalizations.of(context)!.newer,
        'Older': AppLocalizations.of(context)!.older,
      };
    });
  }

  List<Blog> displayList = [];

  void updateList(String value) {
    setState(() {
      displayList = displayList
          .where((element) =>
              element.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: ButtonBlack),
        title: Text((AppLocalizations.of(context)!.titleBlogs),
            style: TextStyle(color: ButtonBlack)),
        backgroundColor: Background,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                icon: Icon(Icons.filter_list, color: ButtonBlack),
                itemBuilder: (context) {
                  return _filterTranslations.keys.map((String key) {
                    return PopupMenuItem<String>(
                      value: key,
                      child: Text(
                        _filterTranslations[key]!,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList();
                },
                onSelected: (String newValue) {
                  setState(() {
                    _selectedFilter = newValue;
                    _updateBlogsFuture();
                  });
                },
              ),
              SizedBox(width: 16),
              Visibility(
                visible: _filterTranslations[_selectedFilter] ==
                    _filterTranslations['Date'],
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.sort, color: ButtonBlack),
                  itemBuilder: (context) {
                    return _directionTranslations.keys.map((String key) {
                      return PopupMenuItem<String>(
                        value: key,
                        child: Text(
                          _directionTranslations[key]!,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (String newValue) {
                    setState(() {
                      _selectedDirection = newValue;
                      _updateBlogsFuture();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor:
          _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                  _updateBlogsFuture();
                },
                decoration: InputDecoration(
                  hintText: "Search blog...",
                  hintStyle: TextStyle(
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black),
                  prefixIcon: Icon(Icons.search,
                      color: _themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Background), // Change the border color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey), // Change the border color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Blog>>(
              future: _filteredBlogsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  // Apply search filter to the sorted blogs
                  List<Blog> filteredBlogs = _sortedBlogs.where((blog) {
                    return blog.title
                        .toLowerCase()
                        .contains(_searchText.toLowerCase());
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredBlogs.length, // Use the sorted data
                    itemBuilder: (context, index) {
                      Blog blog = filteredBlogs[index];
                      return customListTile(blog, context, _themeMode);
                    },
                  );
                } else {
                  return Center(child: Text('No blogs found.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAll(CreateBlog());
        },
        child: Text(AppLocalizations.of(context)!.buttonCreateBlog,
            style: TextStyle(color: ButtonBlack, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        backgroundColor: Background,
      ),
    );
  }

  void _updateBlogsFuture() {
    setState(() {
      if (_selectedFilter == 'Date') {
        _filteredBlogsFuture = BlogController().getBlogs();
        _filteredBlogsFuture = _filteredBlogsFuture!.then((blogs) {
          if (_selectedDirection == 'Newer') {
            blogs.sort((a, b) {
              DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.date);
              DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.date);
              return dateB.compareTo(dateA);
            });
          } else if (_selectedDirection == 'Older') {
            blogs.sort((a, b) {
              DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.date);
              DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.date);
              return dateA.compareTo(dateB);
            });
          }
          _sortedBlogs = List.from(blogs);
          displayList = List.from(blogs);
          return blogs;
        });
      } else if (_selectedFilter == 'Popularity') {
        _filteredBlogsFuture = BlogController().getBlogs();
        _filteredBlogsFuture = _filteredBlogsFuture!.then((blogs) {
          blogs.sort((a, b) {
            int likesA = a.usersLiked.length;
            int likesB = b.usersLiked.length;

            if (likesA == likesB) {
              DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.date);
              DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.date);
              return dateB.compareTo(dateA);
            }
            return likesB.compareTo(likesA);
          });
          _sortedBlogs = List.from(blogs);
          displayList = List.from(blogs);
          return blogs;
        });
      }
    });
  }
}
