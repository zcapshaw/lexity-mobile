import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(
  nullable: true,
  includeIfNull: false,
)
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
  int twitterId;
  Map list;

  bool get hasTwitterConnected => twitterId != null;
}
