import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  //UserService();
  final storage = const FlutterSecureStorage();

  final String baseURL = 'http://192.168.178.80:3000/api';

  saveToken(String token) async {
    await storage.write(key: 'token', value: token);
    print('TOKEN SAVED');
  }

  getToken() async {
    var token = await storage.read(key: 'token');
    print('getToke: $token');
    return token;
  }

  Future signUp(userData) async {
    String url = '$baseURL/user/sign-up';
    print('URL: $url');

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData));

    print(response.body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('response @signUp: $data');

      return data;
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to check credentials.');
    }
  }

  Future<dynamic> login(credentials) async {
    String url = '$baseURL/user/login';
    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(credentials));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      print('response @login: $data');

      await saveToken(token);

      return data;
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to check credentials.');
    }
  }

  Future getUserID() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    print('Token $token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      var userID = decodedToken['userID'];
      //print('Decoded token: $decodedToken');
      print('UserID: $userID');
      return userID;
    } else {
      return null;
    }
  }

  Future getUserData(userID) async {
    //var userID = await getUserID();

    final String url = '$baseURL/user/get-user?userID=$userID';
    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userData = data['result'][0];
      print('response @getUser: $data');

      return userData;
    } else {
      throw Exception('Failed to check credentials.');
    }
  }

  Future<bool> autoLogin() async {
    // Get the userID from the token
    var userID = await getUserID();

    if (userID == null) {
      print("No token found or invalid token");
      return false; // Exit early if no userID is available
    }

    // Check if the user exists in the database
    bool userExists = await checkUserInDatabase(userID);

    if (userExists) {
      print("User exists, proceed with auto-login");
      return true;
      // Continue to auto-login logic (e.g., navigate to home screen)
    } else {
      print("User does not exist, redirect to login screen");
      // Handle user not found (e.g., clear token, navigate to login screen)
      return false;
    }
  }

  Future<bool> checkUserInDatabase(userID) async {
    try {
      // Make the HTTP POST request
      String url = '$baseURL/user/check-user';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userID': userID}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['exists'] ?? false;
      } else {
        print("Server error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error checking user in database: $e");
      return false;
    }
  }

  Future<List<dynamic>> getUserRatings(int userId) async {
    final response = await http.get(
      Uri.parse('$baseURL/ratings/get-ratings?userID=$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      final List<dynamic> ratings = decoded['ratings'];

      return ratings;
    } else {
      throw Exception('Fehler beim Laden der Ratings');
    }
  }
}
