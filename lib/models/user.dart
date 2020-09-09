import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

import 'package:lexity_mobile/utils/parse_bool.dart';

class UserModel extends ChangeNotifier {
  final storage = new FlutterSecureStorage(); // Create storage
  User appUser = new User();

  UserModel() {
    //_deleteAll(); // used to temporarily clear storage during testing
    _init();
  }

  void addOrUpdateUser(bool authN,
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
    appUser.authN = authN;
    appUser.id = id ?? appUser.id;
    appUser.accessToken = accessToken ?? appUser.accessToken;
    appUser.name = name ?? appUser.name;
    appUser.username = username ?? appUser.username;
    appUser.profileImg = profileImg ?? appUser.profileImg;
    appUser.email = email ?? appUser.email;
    appUser.verified = verified ?? appUser.verified;
    appUser.bio = bio ?? appUser.bio;
    appUser.website = website ?? appUser.website;
    appUser.joined = joined ?? appUser.joined;
    appUser.followers = followers ?? appUser.followers;
    appUser.friends = friends ?? appUser.friends;
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
    notifyListeners();
  }

  void logout() {
    appUser.authN = false;
    _writeStorage('authN', authN.toString());
    notifyListeners();
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

  // initialize the new user from values in local secure storage
  Future<void> _init() async {
    appUser = await User.create();
    print(
        'id: ${appUser.id}, token: ${appUser.accessToken}, authN: ${appUser.authN}, createComplete: ${appUser.createComplete}');
    notifyListeners();
  }

  Future<Null> _writeStorage(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<Null> _deleteAll() async {
    await storage.deleteAll();
  }
}

class User {
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

  // Default constructor
  User() {
    createComplete = false;
    id = '';
    accessToken = '';
    authN = null;
  }

  // Private constructor
  User._create() {
    print('_create() (private constructor)');
  }

  /// Public factory
  static Future<User> create() async {
    print('create() (public factory)');

    // Call the private constructor
    var appUser = User._create();

    // Do initialization that requires async
    final storage = new FlutterSecureStorage(); // Create storage
    Map<String, String> allValues = await storage.readAll();
    appUser.createComplete = true;
    appUser.id = allValues['userId'];
    appUser.accessToken = allValues['accessToken'];
    appUser.authN = allValues['authN'].parseBool();
    appUser.name = allValues['name'] ?? '';
    appUser.username = allValues['username'] ?? '';
    appUser.profileImg = allValues['profileImg'] ?? '';
    appUser.email = allValues['email'] ?? '';
    appUser.verified = allValues['verified'].parseBool();
    appUser.bio = allValues['bio'] ?? '';
    appUser.website = allValues['website'] ?? '';
    appUser.joined = allValues['joined'] == null
        ? 0
        : int.tryParse(allValues['joined']) ?? 0;
    appUser.followers = allValues['followers'] == null
        ? 0
        : int.tryParse(allValues['followers']) ?? 0;
    appUser.friends = allValues['friends'] == null
        ? 0
        : int.tryParse(allValues['friends']) ?? 0;

    // Return the fully initialized object
    return appUser;
  }
}
