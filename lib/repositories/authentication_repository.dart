import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lexity_mobile/utils/utils.dart';

/// This class hold all authentication logic. It exposes methods to the
/// AuthenticationBloc for interacting with Auth APIs.
class AuthenticationRepository {
  var urlLauncher = UrlLauncher();

  Future<void> logInWithService(LogInService service) async {
    // Same URL structure is used for all third party login services
    final res = await http
        .get('https://api.lexity.co/auth/${service.toShortString()}/signin');
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body) as Map;
      if (Platform.isIOS) {
        await urlLauncher.launchInWebViewOrVC(
            decoded['url'] as String, true, true);
      } else if (Platform.isAndroid) {
        await urlLauncher.launchInWebViewOrVC(
            decoded['url'] as String, false, false);
      } else {
        throw Exception('Warning: Platform is NOT iOS or Android');
      }
    } else {
      throw Exception(
          // ignore: lines_longer_than_80_chars
          'Error with ${service.toShortString} signin - status: ${res.statusCode}');
    }
  }
}
