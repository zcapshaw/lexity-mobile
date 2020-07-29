import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class UserModel extends ChangeNotifier {
  final storage = new FlutterSecureStorage(); // Create storage
  User appUser = new User();

  UserModel() {
    // _deleteAll(); // used to temporarily clear storage during testing
    _init();
  }

  void addAuth(String id, String accessToken, bool authN) {
    appUser.id = id;
    appUser.accessToken = accessToken;
    appUser.authN = authN;
    _writeStorage('userId', id);
    _writeStorage('accessToken', accessToken);
    _writeStorage('authN', authN.toString());
    print('made some updates in user model - true here? $authN');
    notifyListeners();
  }

  void logout() {
    appUser.authN = false;
    _writeStorage('authN', authN.toString());
    notifyListeners();
  }

  bool get authN => appUser.authN ?? false;

  // initialize the new user from values in local secure storage
  Future<void> _init() async {
    appUser = await User.create();
    print(
        'id: ${appUser.id}, token: ${appUser.accessToken}, authN: ${appUser.authN}');
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
  String id;
  String accessToken;
  bool authN;

  // Default constructor
  User() {
    id = null;
    accessToken = null;
    authN = false;
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
    appUser.id = allValues['userId'];
    appUser.accessToken = allValues['accessToken'];
    appUser.authN = allValues['authN'].parseBool();

    // Return the fully initialized object
    return appUser;
  }
}

// Quick class to convert string to bool
extension BoolParsing on String {
  bool parseBool() {
    if (this != null) {
      return this.toLowerCase() == 'true';
    } else {
      return false;
    }
  }
}
