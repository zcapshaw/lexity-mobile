class User {
  User({
    this.createComplete = false,
    this.id = '',
    this.accessToken = '',
    this.authN,
  });

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
