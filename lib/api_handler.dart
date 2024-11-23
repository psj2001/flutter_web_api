import 'dart:convert';
import 'dart:developer';
import 'package:flutter_web_api/Model.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  final String baseUrl = "";

  Future<List<User>> getUserData() async {
    List<User> data = [];
    final uri = Uri.parse(baseUrl);
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        log('Response body: ${response.body}');
        final List<dynamic> jsonData = jsonDecode(response.body);
        data = jsonData.map((json) => User.fromJson(json)).toList();
      } else {
        log('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log("Error: $e");
      log("StackTrace: $stackTrace");
    }
    return data;
  }

  Future<http.Response> updateUser(
      {required int userId, required User user}) async {
    final uri = Uri.parse("$baseUrl/$userId");
    late http.Response response;
    try {
      response = await http.put(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(user));
    } catch (e) {
      return response;
    }
    return response;
  }

  //Post
  Future<http.Response> addUser({required User user}) async {
    final uri = Uri.parse(baseUrl);
    late http.Response response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(user));
    } catch (e) {
      return response;
    }
    return response;
  }

  //Delete
  Future<http.Response> deleteUser({required int userId}) async {
    final uri = Uri.parse("$baseUrl/$userId");
    late http.Response response;
    try {
      response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    } catch (e) {
      return response;
    }
    return response;
  }

  Future<User> getUserById({required int userId}) async {
    final uri = Uri.parse("$baseUrl/$userId");
    User? user;
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        log('Response body: ${response.body}');
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        user = User.fromJson(jsonData);
      } else {
        log('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log("Error: $e");
      log("StackTrace: $stackTrace");
    }
    return user!;
  }
}
