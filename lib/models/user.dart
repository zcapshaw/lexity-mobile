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
}
