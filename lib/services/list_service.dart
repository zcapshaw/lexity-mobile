import 'package:flutter_dotenv/flutter_dotenv.dart';

//TODO: add all my API call functions to this service
class ListService {
  static const String user = 'Users/74763';
  static String userJwt = DotEnv().env['USER_JWT'];

  static const API = 'https://stellar-aurora-280316.uc.r.appspot.com';
  final headers = {
    'access-token': '$userJwt',
  };
}
