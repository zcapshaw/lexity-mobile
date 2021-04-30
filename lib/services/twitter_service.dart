import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lexity_mobile/utils/utils.dart';

class TwitterService {
  // ignore: constant_identifier_names
  static const API = 'https://api.lexity.co';

  Future<APIResponse<Object>> searchTwitterUsers(
      String accessToken, String userId, String query) async {
    return http.get(
      '$API/twitter/search/user?userId=$userId&q=$query',
      headers: {'access-token': accessToken},
    ).then((res) {
      if (res.statusCode == 200) {
        return APIResponse<Object>(data: res.body);
      }
      return APIResponse<Object>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<Object>(
          error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse> shareTwitterNotes(
      String accessToken, String userId, List<String> notes) {
    final jsonPayload = jsonEncode({
      'userId': userId,
      'notes': notes,
    });

    return http
        .post(
      '$API/twitter/share/notes',
      headers: {
        'access-token': accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonPayload,
    )
        .then((res) {
      if (res.statusCode == 200) {
        return APIResponse<bool>(responseBody: res.body, error: false);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase,
          responseBody: res.body);
    }).catchError(
      (dynamic err) => const APIResponse<bool>(
          error: true, errorMessage: 'An error occured'),
    );
  }
}
