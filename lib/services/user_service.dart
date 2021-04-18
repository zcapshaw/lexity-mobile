import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/utils/utils.dart';

class UserService {
  // ignore: constant_identifier_names
  static const API = 'https://api.lexity.co';

  Future<APIResponse> updateUser(User user, Map userUpdate) {
    final jsonItem = jsonEncode({'userId': user.id, 'userUpdate': userUpdate});
    return http
        .post(
      '$API/user/update',
      headers: {
        'access-token': user.accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonItem,
    )
        .then((res) {
      if (res.statusCode == 200) {
        return const APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<bool>(
          error: true, errorMessage: 'An error occured'),
    );
  }
}
