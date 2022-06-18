import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIHelper {
  APIHelper._internal();
  static final APIHelper _apiHelper = APIHelper._internal();
  static APIHelper get sharedInstance => _apiHelper;

  Future<http.Response?> doGet({required String url}) async {
    try {
      var response = await http.get(Uri.parse(url));
      debugPrint("=================================");
      debugPrint("doGet url : $url");
      debugPrint("doGet response statusCode : ${response.statusCode}");
      debugPrint("doGet response result body : ${response.body}");
      debugPrint("=================================");
      return response;
    } catch (exception) {
      developer.log(
        "got exception: $exception",
        error: jsonEncode(exception),
      );
      return null;
    }
  }

  Future<http.Response?> doPost({
    required String url,
    required String body,
  }) async {
    try {
      var response = await http.post(Uri.parse(url), body: body);

      debugPrint("=================================");
      debugPrint("doPost url : $url");
      debugPrint("doPost ubodyrl : $body");
      debugPrint("doPost response statusCode : ${response.statusCode}");
      debugPrint("doPost response result body : ${response.body}");
      debugPrint("=================================");
      return response;
    } catch (exception) {
      developer.log(
        "got exception: $exception",
        error: jsonEncode(exception),
      );
      return null;
    }
  }
}
