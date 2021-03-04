import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:lexity_mobile/utils/utils.dart';

/// This class hold all authentication logic. It exposes methods to the
/// AuthenticationBloc for interacting with Auth APIs.
class AuthenticationRepository {
  Future<void> logInWithService(LogInService service) async {
    // Same URL structure is used for all third party login services
    final res = await http
        .get('https://api.lexity.co/auth/${service.toShortString()}/signin');
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body) as Map;
      if (Platform.isIOS) {
        await _launchInWebViewOrVC(decoded['url'] as String, true, true);
      } else if (Platform.isAndroid) {
        await _launchInWebViewOrVC(decoded['url'] as String, false, false);
      } else {
        throw Exception('Warning: Platform is NOT iOS or Android');
      }
    } else {
      throw Exception(
          // ignore: lines_longer_than_80_chars
          'Error with ${service.toShortString} signin - status: ${res.statusCode}');
    }
  }

  Future<void> _launchInWebViewOrVC(
      String url, bool forceSafariVC, bool forceWebView) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: forceSafariVC,
        forceWebView: forceWebView,
      );
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
