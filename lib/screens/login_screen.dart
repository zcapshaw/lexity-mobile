import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http; // Will use when integrating API

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    'SIGN UP WITH TWITTER',
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
                    print('Sign up for Twitter');
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
                    'SIGN UP WITH APPLE',
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
                    print('Sign up for Apple');
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    print('Sign in');
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        letterSpacing: 0.4,
                        height: 1.5,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign in',
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
