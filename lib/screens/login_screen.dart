import 'dart:async';
import 'package:lexity_mobile/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StreamSubscription _sub; // subscribe to stream of incoming lexity:// URIs
  var user; // global user for use in class methods
  String twitterButtonText = 'SIGN UP WITH TWITTER';
  String appleButtonText = 'SIGN UP WITH APPLE';
  String sentenceOne = 'Already have an account? ';
  String sentenceTwo = 'Sign in';
  bool signUp = true;

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = Provider.of<UserModel>(context, listen: false);
    initUniLinks(); // initialize the URI stream
  }

  @override
  dispose() {
    if (_sub != null) _sub.cancel();
    super.dispose();
  }

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void _signUpWithTwitter() async {
    final http.Response res =
        await http.get('http://localhost:3000/auth/twitter/signin');
    if (res.statusCode == 200) {
      final Map decoded = jsonDecode(res.body);
      _launchInWebViewOrVC(decoded['url']);
    } else {
      print(res.statusCode);
      print(res.reasonPhrase);
      print(res.body);
    }
  }

  void _signUpWithApple() async {
    print('Signup with Apple');
  }

  // TODO: need setup app linking for Android as well
  Future<Null> initUniLinks() async {
    _sub = getUriLinksStream().listen((Uri uri) {
      final accessToken = uri.queryParameters['access_token'];
      final userId = uri.queryParameters['user_id'];
      if (accessToken.isNotEmpty && userId.isNotEmpty) {
        user.addAuth(userId, accessToken, true);
      } else {
        // TODO: Consider showing a SnackBar with login error to user
        print('Could not authenticate user');
        print(uri.queryParameters['error']);
      }
      closeWebView();
    }, onError: (err) {
      print(err);
    });
  }

  void _toggleSignin() {
    setState(() {
      signUp = !signUp;
      twitterButtonText =
          signUp ? 'SIGN UP WITH TWITTER' : 'SIGN IN WITH TWITTER';
      appleButtonText = signUp ? 'SIGN UP WITH APPLE' : 'SIGN IN WITH APPLE';
      sentenceOne =
          signUp ? 'Already have an account? ' : 'Don\'t have an account? ';
      sentenceTwo = signUp ? 'Sign in' : 'Sign up';
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(70, 0, 70, 20),
                  child: Image.asset('assets/undraw_book_lover.png')),
              Container(
                child: Text(
                  'Welcome to Lexity',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
                child: Text(
                  'Read great books. Share big ideas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    letterSpacing: 0.4,
                    height: 1.5,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: OutlineButton.icon(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  borderSide: BorderSide(color: Colors.grey[400]),
                  label: Text(
                    twitterButtonText,
                    style: TextStyle(
                      color: Colors.grey[600],
                      letterSpacing: 0.3,
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.twitter,
                    color: Color(0xFF00ACEE),
                  ),
                  onPressed: () {
                    _signUpWithTwitter();
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                margin: EdgeInsets.only(top: 5),
                child: OutlineButton.icon(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  borderSide: BorderSide(color: Colors.grey[400]),
                  label: Text(
                    appleButtonText,
                    style: TextStyle(
                      color: Colors.grey[600],
                      letterSpacing: 0.3,
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.apple,
                    color: Color(0xFF000000),
                  ),
                  onPressed: () {
                    _signUpWithApple();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    _toggleSignin();
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: sentenceOne,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        letterSpacing: 0.4,
                        height: 1.5,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: sentenceTwo,
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Image.asset(
          'assets/signin_bottom.png',
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
