import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  // Default constructor
  User() {
    createComplete = false;
    id = '';
    accessToken = '';
    authN = null;
  }

  bool createComplete;
  String id;
  String accessToken;
  bool authN;
  String name;
  String username;
  String profileImg;
  String email;
  bool verified;
  String bio;
  String website;
  int joined;
  int followers;
  int friends;

  /// Public factory
  static Future<User> create() async {
    // Call the private constructor
    var appUser = User();

    // Do initialization that requires async
    final storage = const FlutterSecureStorage(); // Create storage
    Map allValues = await storage.readAll();
    appUser
      ..createComplete = true
      ..id = allValues['userId']
      ..accessToken = allValues['accessToken']
      ..authN = allValues['authN'].toLowerCase() == 'true'
      ..name = allValues['name'] ?? ''
      ..username = allValues['username'] ?? ''
      ..profileImg = allValues['profileImg'] ?? ''
      ..email = allValues['email'] ?? ''
      ..verified = allValues['verified'].toLowerCase() == 'true'
      ..bio = allValues['bio'] ?? ''
      ..website = allValues['website'] ?? ''
      ..joined = allValues['joined'] == null
          ? 0
          : int.tryParse(allValues['joined']) ?? 0
      ..followers = allValues['followers'] == null
          ? 0
          : int.tryParse(allValues['followers']) ?? 0
      ..friends = allValues['friends'] == null
          ? 0
          : int.tryParse(allValues['friends']) ?? 0;

    // Return the fully initialized object
    return appUser;
  }
}
