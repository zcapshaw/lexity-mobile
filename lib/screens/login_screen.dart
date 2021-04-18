import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lexity_mobile/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:lexity_mobile/utils/enums.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginScreen());
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool signUp = true;

  void _logInWithTwitter() {
    context
        .bloc<AuthenticationBloc>()
        .add(const LogInWithService(LogInService.twitter));
  }

  void _loginWithApple() {
    context
        .bloc<AuthenticationBloc>()
        .add(const LogInWithService(LogInService.apple));
  }

  void _toggleSignin() {
    setState(() {
      signUp = !signUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/signin_bottom.png'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.fromLTRB(70, 0, 70, 20),
                            child: Image.asset('assets/undraw_book_lover.png')),
                        Container(
                          child: Text(
                            'Welcome to Lexity',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 30),
                          child: Text('Read great books. Share big ideas.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle2),
                        ),
                        SignUpButton(
                          buttonText: signUp
                              ? 'SIGN UP WITH TWITTER'
                              : 'SIGN IN WITH TWITTER',
                          callback: _logInWithTwitter,
                          icon: const FaIcon(
                            FontAwesomeIcons.twitter,
                            color: Color(0xFF00ACEE),
                          ),
                        ),
                        if (Platform.isIOS)
                          SignUpButton(
                            buttonText: signUp
                                ? 'SIGN UP WITH APPLE'
                                : 'SIGN IN WITH APPLE',
                            callback: _loginWithApple,
                            icon: const FaIcon(
                              FontAwesomeIcons.apple,
                              color: Color(0xFF000000),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: _toggleSignin,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: signUp
                                    ? 'Already have an account? '
                                    : 'Don\'t have an account? ',
                                style: Theme.of(context).textTheme.subtitle2,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: signUp ? 'Sign in' : 'Sign up',
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({this.callback, this.buttonText, this.icon});

  final void Function() callback;
  final String buttonText;
  final FaIcon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: const EdgeInsets.only(top: 5),
      child: OutlineButton.icon(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        borderSide: BorderSide(color: Colors.grey[400]),
        label: Text(
          buttonText,
          style: TextStyle(
            color: Colors.grey[600],
            letterSpacing: 0.3,
          ),
        ),
        icon: icon,
        onPressed: callback,
      ),
    );
  }
}
