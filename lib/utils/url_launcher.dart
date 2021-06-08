import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  Future<void> launchInWebViewOrVC(String url) async {
    if (Platform.isIOS || Platform.isAndroid) {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: Platform.isIOS ? true : false,
          forceWebView: Platform.isIOS ? true : false,
        );
      } else {
        throw Exception('Could not launch $url');
      }
    } else {
      throw Exception('Warning: Platform is NOT iOS or Android');
    }
  }
}
