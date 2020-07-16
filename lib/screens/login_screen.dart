import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/semantics.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container (
          margin: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(70, 0, 70, 20),
                child: Image.asset('assets/undraw_book_lover.png')
              ),
              Container(
                child: Text(
                  'Welcome to Lexity',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text(
                  'Read great books. Share big ideas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                    letterSpacing: 0.4,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

    ),
    );
  }
}