class User {
  User(
      {this.createComplete = false,
      this.id = '',
      this.accessToken = '',
      this.authN,
      this.list});

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
  int twitterId;
  Map list;

  bool get hasTwitterConnected => twitterId != null;
}
