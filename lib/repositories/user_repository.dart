import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final storage = const FlutterSecureStorage(); // Create storage
  User appUser = User();

  Future<bool> getLexityUserFromUri(Uri uri) async {
    final accessToken = uri.queryParameters['access_token'];
    final userId = uri.queryParameters['user_id'];

    if (accessToken.isNotEmpty && userId.isNotEmpty) {
      final res = await http
          .get('https://api.lexity.co/user/info/?userId=$userId', headers: {
        'access-token': '$accessToken',
      });
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map;
        _addOrUpdateUser(true,
            id: userId,
            accessToken: accessToken,
            name: decoded['name'] as String,
            username: decoded['username'] as String,
            profileImg: decoded['profileImg'] as String,
            email: decoded['email'] as String,
            verified: decoded['verified'] as bool,
            bio: decoded['bio'] as String,
            website: decoded['website'] as String,
            joined: decoded['joined'] as int,
            followers: decoded['followers'] as int,
            friends: decoded['friends'] as int);
        return true;
      } else {
        print('Error loaded user from database - status: ${res.statusCode}');
        return false;
      }
    } else {
      // TODO: Consider showing a SnackBar with login error to user
      print('Could not authenticate user');
      return false;
    }
  }

  Future<bool> checkForCachedUser() async {
    // await _deleteAll();
    Map allValues = await storage.readAll();

    if (allValues.containsKey('userId') && allValues['userId'] != '') {
      appUser
        ..createComplete = true
        ..id = allValues['userId'] as String
        ..accessToken = allValues['accessToken'] as String
        ..authN = allValues['authN'].toLowerCase() == 'true'
        ..name = allValues['name'] as String ?? ''
        ..username = allValues['username'] as String ?? ''
        ..profileImg = allValues['profileImg'] as String ?? ''
        ..email = allValues['email'] as String ?? ''
        ..verified = allValues['verified'].toLowerCase() == 'true'
        ..bio = allValues['bio'] as String ?? ''
        ..website = allValues['website'] as String ?? ''
        ..joined =
            allValues['joined'] == null ? 0 : allValues['joined'] as int ?? 0
        ..followers = allValues['followers'] == null
            ? 0
            : allValues['followers'] as int ?? 0
        ..friends =
            allValues['friends'] == null ? 0 : allValues['friends'] as int ?? 0;
      print('user id from storage is: ${allValues['userId']}');
      return true;
    } else {
      print('no cached user found');
      return false;
    }
  }

  void _addOrUpdateUser(bool authN,
      {String id,
      String accessToken,
      String name,
      String username,
      String profileImg,
      String email,
      bool verified,
      String bio,
      String website,
      int joined,
      int followers,
      int friends}) {
    appUser
      ..authN = authN
      ..id = id ?? appUser.id
      ..accessToken = accessToken ?? appUser.accessToken
      ..name = name ?? appUser.name
      ..username = username ?? appUser.username
      ..profileImg = profileImg ?? appUser.profileImg
      ..email = email ?? appUser.email
      ..verified = verified ?? appUser.verified
      ..bio = bio ?? appUser.bio
      ..website = website ?? appUser.website
      ..joined = joined ?? appUser.joined
      ..followers = followers ?? appUser.followers
      ..friends = friends ?? appUser.friends;
    _writeStorage('userId', appUser.id);
    _writeStorage('accessToken', appUser.accessToken);
    _writeStorage('authN', appUser.authN.toString());
    _writeStorage('name', appUser.name);
    _writeStorage('username', appUser.username);
    _writeStorage('profileImg', appUser.profileImg);
    _writeStorage('email', appUser.email);
    _writeStorage('verified', appUser.verified.toString());
    _writeStorage('bio', appUser.bio);
    _writeStorage('website', appUser.website);
    _writeStorage('joined', appUser.joined.toString());
    _writeStorage('followers', appUser.followers.toString());
    _writeStorage('friends', appUser.friends.toString());
  }

  // create getters
  bool get createComplete => appUser.createComplete ?? false;
  String get id => appUser.id;
  String get accessToken => appUser.accessToken;
  bool get authN => appUser.authN ?? false;
  String get name => appUser.name;
  String get username => appUser.username;
  String get profileImg => appUser.profileImg;
  String get email => appUser.email;
  bool get verified => appUser.verified;
  String get bio => appUser.bio;
  String get website => appUser.website;
  int get joined => appUser.joined;
  int get followers => appUser.followers;
  int get friends => appUser.friends;
  User get currentUser => appUser;

  Future<Null> _writeStorage(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  // Allows clearing of local storage for testing purposes
  // ignore: unused_element
  Future<Null> _deleteAll() async {
    await storage.deleteAll();
  }
}
