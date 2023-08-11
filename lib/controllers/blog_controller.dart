import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:frontend/models/blog.dart';
import 'package:frontend/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/comment.dart';

class BlogController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  TextEditingController commentController = TextEditingController();
  TextEditingController replyController = TextEditingController();

  final LocalStorage storage = new LocalStorage('My App');

  Future<String> createBlog(String imageUrl) async {
    try {
      print("imageUrl: " + imageUrl);
      print("createBlog: " + currentUser.id);
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('http://10.0.2.2:5432/api/blogs');
      Map body = {
        'title': titleController.text.trim(),
        'description': descriptionController.text,
        'body_text': contentController.text,
        'author': currentUser.id,
        'date': formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]),
        'imageUrl': imageUrl,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == "Blog saved") {
          titleController.clear();
          descriptionController.clear();
          contentController.clear();
          currentPhoto = "";
          Get.off(HomeScreen());
        } else if (json['status'] == false) {
          var message = jsonDecode(response.body)['message'];
          return message;
        }
      } else {
        var message2 = jsonDecode(response.body)['message'];
        return message2;
      }
      return "Unknown Error Occured";
    } catch (error) {
      Get.back();
      return "Unknown Error Occured";
    }
  }

  Future<List<Blog>> getBlogs() async {
    List<Blog> blogs = [];
    final data = await http.get(Uri.parse('http://10.0.2.2:5432/api/blogs/'));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Blog blog = Blog(
        id: u["_id"],
        title: u["title"],
        description: u["description"],
        body_text: u["body_text"],
        author: u["author"],
        imageUrl: u["imageUrl"],
        date: u["date"],
        usersLiked: u["usersLiked"],
      );

      blogs.add(blog);
    }
    return blogs;
  }

  void addComment(idBlog) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      var url =
          Uri.parse('http://10.0.2.2:5432/api/blogs/addcomment/' + idBlog);
      Map body = {
        'content': commentController.text.trim(),
        'owner': currentUser.id,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      await getComments(idBlog);
      if (response.statusCode == 200) {
        commentController.clear();
      } else {
        print("incorrecto");
      }
    } catch (error) {
      Get.back();
    }
  }

  void addReply(idComment) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      var url =
          Uri.parse('http://10.0.2.2:5432/api/blogs/addreply/' + idComment);
      Map body = {
        'content': replyController.text.trim(),
        'owner': currentUser.id,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        print("correcto");
        replyController.clear();
      } else {
        print("incorrecto");
      }
    } catch (error) {
      Get.back();
    }
  }

  void editBlog(idBlog, imageUrl) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      var url = Uri.parse('http://10.0.2.2:5432/api/blogs/edit/' + idBlog);

      Map body = {
        'title': titleController.text.trim(),
        'description': descriptionController.text,
        'body_text': contentController.text,
        'imageUrl': imageUrl,
      };

      http.Response response =
          await http.put(url, body: jsonEncode(body), headers: headers);

      await getBlogs();

      if (response.statusCode == 200) {
        titleController.clear();
        descriptionController.clear();
        contentController.clear();
      } else {
        print("incorrecto");
      }
    } catch (e) {}
  }

  Future<List<Comments>> getComments(idBlog) async {
    List<Comments> comments = [];
    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/blogs/comments/' + idBlog));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      List<Map<String, dynamic>> replies =
          (u["replies"] as List<dynamic>).cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> likes = (u["likes"] != null)
          ? (u["likes"] as List<dynamic>).cast<Map<String, dynamic>>()
          : []; // Convert to List<Map<String, dynamic>>
      List<Map<String, dynamic>> dislikes = (u["dislikes"] != null)
          ? (u["dislikes"] as List<dynamic>).cast<Map<String, dynamic>>()
          : []; // Convert to List<Map<String, dynamic>>
      Comments comment = Comments(
        id: u["_id"],
        content: u["content"],
        owner: u["owner"],
        likes: likes,
        dislikes: dislikes,
        replies: replies,
      );

      // Check if the user has liked the comment
      final hasLiked =
          u["likes"] != null && u["likes"].contains(currentUser.id);
      comment.liked = hasLiked;

      final hasDisliked =
          u["dislikes"] != null && u["dislikes"].contains(currentUser.id);
      comment.disliked = hasDisliked;

      comments.add(comment);
    }
    return comments;
  }

  // Function to add a like to a comment
  void addLikeToComment(String commentId) async {
    final comment = await getOneComment(commentId);
    final response = await http.post(Uri.parse(
        'http://10.0.2.2:5432/api/blogs/like/' +
            commentId +
            '/' +
            currentUser.id));
    if (response.statusCode == 200) {
      // Like added successfully
      comment.liked = true;
      print('Like added successfully');
    } else {
      // Handle error response
      print('Failed to add like');
    }
  }

  void cancelLikeToComment(String commentId) async {
    final comment = await getOneComment(commentId);
    final response = await http.delete(Uri.parse(
        'http://10.0.2.2:5432/api/blogs/cancellike/' +
            commentId +
            '/' +
            currentUser.id));
    if (response.statusCode == 200) {
      // Like added successfully
      comment.liked = false;
      print('Like added successfully');
    } else {
      // Handle error response
      print('Failed to add like');
    }
  }

  void addDislikeToComment(String commentId) async {
    final comment = await getOneComment(commentId);
    final response = await http.post(Uri.parse(
        'http://10.0.2.2:5432/api/blogs/dislike/' +
            commentId +
            '/' +
            currentUser.id));

    if (response.statusCode == 200) {
      // Like added successfully
      comment.disliked = true;
      print('Like added successfully');
    } else {
      // Handle error response
      print('Failed to add like');
    }
  }

  void cancelDislikeToComment(String commentId) async {
    final comment = await getOneComment(commentId);

    final response = await http.delete(Uri.parse(
        'http://10.0.2.2:5432/api/blogs/canceldislike/' +
            commentId +
            '/' +
            currentUser.id));
    if (response.statusCode == 200) {
      // Like added successfully
      comment.disliked = false;
      print('Like added successfully');
    } else {
      // Handle error response
      print('Failed to add like');
    }
  }

  Future<Comments> getOneComment(commentId) async {
    final data = await http.get(
        Uri.parse('http://10.0.2.2:5432/api/blogs/getonecomment/' + commentId));
    var jsonData = json.decode(data.body);

    List<Map<String, dynamic>> replies =
        (jsonData["replies"] as List<dynamic>).cast<Map<String, dynamic>>();
    List<Map<String, dynamic>> likes = (jsonData["likes"] != null)
        ? (jsonData["likes"] as List<dynamic>).cast<Map<String, dynamic>>()
        : []; // Convert to List<Map<String, dynamic>>
    List<Map<String, dynamic>> dislikes = (jsonData["ldisikes"] != null)
        ? (jsonData["dislikes"] as List<dynamic>).cast<Map<String, dynamic>>()
        : [];
    Comments comment = Comments(
      id: jsonData["_id"],
      content: jsonData["content"],
      owner: jsonData["owner"],
      likes: likes,
      dislikes: dislikes,
      replies: replies,
    );

    return comment;
  }

  Future<Blog> getOneBlog(idBlog) async {
    final data =
        await http.get(Uri.parse('http://10.0.2.2:5432/api/blogs/' + idBlog));

    var jsonData = json.decode(data.body);

    Blog blog = Blog(
      id: jsonData["_id"],
      title: jsonData["title"],
      description: jsonData["description"],
      body_text: jsonData["body_text"],
      author: jsonData["author"],
      imageUrl: jsonData["imageUrl"],
      date: jsonData["date"],
      usersLiked: jsonData["usersLiked"],
    );

    return blog;
  }

  Future<bool> userHasLiked(idBlog) async {
    bool hasLiked = false;
    Blog blog = await getOneBlog(idBlog);
    var a = blog.usersLiked;

    if (a
        .map((participants) => participants["_id"])
        .toList()
        .contains(currentUser.id)) {
      hasLiked = true;
    }
    return hasLiked;
  }

  void addUserLike(idBlog) async {
    await http.put(
      Uri.parse('http://10.0.2.2:5432/api/blogs/likeblog/' +
          currentUser.id +
          '/' +
          idBlog),
    );
  }

  void deleteUserLike(idBlog) async {
    await http.put(
      Uri.parse('http://10.0.2.2:5432/api/blogs/dislikeblog/' +
          currentUser.id +
          '/' +
          idBlog),
    );
  }
}
