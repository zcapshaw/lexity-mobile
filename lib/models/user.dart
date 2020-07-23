import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserModel extends ChangeNotifier {
  final appUser = new User();

  void addAuth(String id, String accessToken, bool authN) {
    appUser.id = id;
    appUser.accessToken = accessToken;
    appUser.authN = authN;
    print('made some updates in user model - true here? $authN');
  }

  bool get authN => appUser.authN;
}

class User {
  String id;
  String accessToken;
  bool authN = false;
}
