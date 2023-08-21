import 'dart:convert';

import 'package:frontend/models/meeting.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:frontend/data/data.dart';
import 'package:frontend/models/comment.dart';
import 'package:frontend/screens/home.dart';

class MeetingController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  TextEditingController commentController = TextEditingController();
  TextEditingController replyController = TextEditingController();

  final LocalStorage storage = new LocalStorage('My App');

  Future<String> createMeeting(currentPhoto) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      print(titleController.text);
      print("controller arriba");

      print('Crear meeting');
      var url = Uri.parse('http://10.0.2.2:5432/api/meetings');
      Map body = {
        'title': titleController.text.trim(),
        'description': descriptionController.text,
        'organizer': currentUser.id,
        'location': locationController.text,
        'registration_fee': feeController.text,
        'date': dateController.text,
        'imageUrl': currentPhoto,
        'lat': latController.text,
        'lng': lngController.text,
      };

      print(body['author']);
      print('datos de crear meeting');
      print(body);

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      print('response de crear meeting');
      print(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("correcto");
        if (json['status'] == "Meeting saved") {
          titleController.clear();
          descriptionController.clear();
          locationController.clear();
          feeController.clear();
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

  void editMeeting(idMeeting, currentPhoto) async {
    print("entra en EditMeeting");
    print("currentPhoto " + currentPhoto);
    try {
      var headers = {'Content-Type': 'application/json'};
      print(replyController.text);

      print('Crear comentario');
      var url =
          Uri.parse('http://10.0.2.2:5432/api/meetings/edit/' + idMeeting);

      Map body = {
        'title': titleController.text.trim(),
        'location': locationController.text.trim(),
        'registration_fee': feeController.text.trim(),
        'date': dateController.text.trim(),
        'description': descriptionController.text,
        'imageUrl': currentPhoto,
        'lat': latController.text,
        'lng': lngController.text,
      };

      print('datos de editar meeting');
      print(body);

      http.Response response =
          await http.put(url, body: jsonEncode(body), headers: headers);

      print('response de editar meeting');
      print(response.body);

      await getMeetings();

      if (response.statusCode == 200) {
        print("correcto");

        titleController.clear();
        locationController.clear();
        feeController.clear();
        dateController.clear();
        descriptionController.clear();
      } else {
        print("incorrecto");
      }
    } catch (e) {}
  }

  Future<List<Meeting>> getMeetings() async {
    List<Meeting> meetings = [];
    final data = await http.get(Uri.parse('http://10.0.2.2:5432/api/meetings'));
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      Meeting meeting = Meeting(
          id: u["_id"],
          title: u["title"],
          description: u["description"],
          organizer: u["organizer"],
          date: u["date"],
          imageUrl: u["imageUrl"],
          location: u["location"],
          registration_fee: u["registration_fee"],
          participants: u["participants"],
          lat: u["lat"],
          lng: u["lng"]);

      meetings.add(meeting);
    }

    return meetings;
  }

  Future<Meeting> getOneMeeting(idMeeting) async {
    final data = await http
        .get(Uri.parse('http://10.0.2.2:5432/api/meetings/' + idMeeting));

    var jsonData = json.decode(data.body);

    Meeting meeting = Meeting(
        id: jsonData["_id"],
        title: jsonData["title"],
        description: jsonData["description"],
        organizer: jsonData["organizer"],
        date: jsonData["date"],
        imageUrl: jsonData["imageUrl"],
        location: jsonData["location"],
        registration_fee: jsonData["registration_fee"],
        participants: jsonData["participants"],
        lat: jsonData["lat"],
        lng: jsonData["lng"]);

    return meeting;
  }

  void addParticipant(idMeeting) async {
    print("Vemos id del jugador a unirse " + currentUser.id);
    print("Vemos id del meeting a unirse " + idMeeting);

    await http.put(
      Uri.parse('http://10.0.2.2:5432/api/meetings/join/' +
          currentUser.id +
          '/' +
          idMeeting),
    );

    print("ha pasado " + currentUser.id);
  }

  void deleteParticipant(idMeeting) async {
    print("Vemos id del jugador a desapuntarse " + currentUser.id);
    print("Vemos id del meeting a desapuntarse " + idMeeting);
    await http.put(
      Uri.parse('http://10.0.2.2:5432/api/meetings/leave/' +
          currentUser.id +
          '/' +
          idMeeting),
    );
    print("ha pasado para desapuntarse " + currentUser.id);
  }

  Future<bool> userIsParticipant(idMeeting) async {
    bool isParticipant = false;
    Meeting meeting = await getOneMeeting(idMeeting);
    var a = meeting.participants;

    print(a.map((participants) => participants["_id"]).toList());

    print(a
        .map((participants) => participants["_id"])
        .toList()
        .contains(currentUser.id));
    print("IMPORTANTE");
    if (a
        .map((participants) => participants["_id"])
        .toList()
        .contains(currentUser.id)) {
      isParticipant = true;
    }

    print(isParticipant);
    return isParticipant;
  }

  void addComment(idMeeting) async {
    print("entra en addComment");
    try {
      var headers = {'Content-Type': 'application/json'};
      print(commentController.text);

      print('Crear comentario');
      var url = Uri.parse(
          'http://10.0.2.2:5432/api/meetings/addcomment/' + idMeeting);
      Map body = {
        'content': commentController.text.trim(),
        'owner': currentUser.id,
      };

      print('datos de crear comentario');
      print(body);

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      print('response de crear comentario');
      print(response.body);

      await getComments(idMeeting);
      if (response.statusCode == 200) {
        print("correcto");
        commentController.clear();
      } else {
        print("incorrecto");
      }
    } catch (error) {
      Get.back();
    }
  }

  void addReply(idComment) async {
    print("entra en addReply");
    try {
      var headers = {'Content-Type': 'application/json'};
      print(replyController.text);

      print('Crear comentario');
      var url =
          Uri.parse('http://10.0.2.2:5432/api/meetings/addreply/' + idComment);
      Map body = {
        'content': replyController.text.trim(),
        'owner': currentUser.id,
      };

      print('datos de crear reply');
      print(body);

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      print('response de crear reply');
      print(response.body);

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

  Future<List<Comments>> getComments(idMeeting) async {
    List<Comments> comments = [];
    print("id Meeting " + idMeeting);
    final data = await http.get(
        Uri.parse('http://10.0.2.2:5432/api/meetings/comments/' + idMeeting));
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
      print("VEmOS OWNER username " + comment.owner['username']);
      comments.add(comment);
    }
    return comments;
  }

  // Function to add a like to a comment
  void addLikeToComment(String commentId) async {
    print(commentId);
    final comment = await getOneComment(commentId);
    final response = await http.post(Uri.parse(
        'http://10.0.2.2:5432/api/meetings/like/' +
            commentId +
            '/' +
            currentUser.id));
    print(response.statusCode);
    print(response.body);
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
    print(commentId);
    final comment = await getOneComment(commentId);
    final response = await http.delete(Uri.parse(
        'http://10.0.2.2:5432/api/meetings/cancellike/' +
            commentId +
            '/' +
            currentUser.id));
    print(response.statusCode);
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
    print(commentId);
    final comment = await getOneComment(commentId);
    final response = await http.post(Uri.parse(
        'http://10.0.2.2:5432/api/meetings/dislike/' +
            commentId +
            '/' +
            currentUser.id));
    print(response.statusCode);
    print(response.body);
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
    print(commentId);
    final comment = await getOneComment(commentId);

    final response = await http.delete(Uri.parse(
        'http://10.0.2.2:5432/api/meetings/canceldislike/' +
            commentId +
            '/' +
            currentUser.id));
    print(response.statusCode);
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
    final data = await http.get(Uri.parse(
        'http://10.0.2.2:5432/api/meetings/getonecomment/' + commentId));
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
}
