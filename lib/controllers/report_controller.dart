import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:war_tracker/constants.dart';
import 'package:war_tracker/data/data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReportController extends GetxController {
  TextEditingController reasonController = TextEditingController();

  Future<String> createReport(String type, String reported) async {
    try {
      print(type);
      print(reported);
      print("createBlog: " + currentUser.id);
      var headers = {'Content-Type': 'application/json'};
      print("a");
      var url = Uri.parse(localurl + '/api/report/report');
      print(url);
      print("b");
      Map body = {
        'owner': currentUser.id,
        'reported': reported,
        'type': type,
        'date': DateTime.now().toString(),
        'reason': reasonController.text,
      };
      print("c");
      print(body);
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      print(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == "Report saved") {
          reasonController.clear();
          return "Report saved";
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
}
