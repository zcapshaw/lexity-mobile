import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lexity_mobile/models/models.dart';

class UserRepository extends ChangeNotifier {
  UserRepository() {
    //_deleteAll(); // used to temporarily clear storage during testing
    _init();
  }

  final storage = const FlutterSecureStorage(); // Create storage
  User appUser = User();

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
    print('id: ${appUser.id}, token: ${appUser.accessToken}');
    print('authN: ${appUser.authN}, createComplete: ${appUser.createComplete}');
    notifyListeners();
  }

  Future<Null> _writeStorage(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<Null> _deleteAll() async {
    await storage.deleteAll();
  }
}
