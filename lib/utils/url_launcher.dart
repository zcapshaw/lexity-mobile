import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  Future<void> launchInWebViewOrVC(
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
