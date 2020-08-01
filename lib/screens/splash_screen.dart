import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:lexity_mobile/models/user.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

void authNav(context) {
  var user = Provider.of<UserModel>(context, listen: true);
  print('User authenticated: ${user.authN}');
  if (user.createComplete && user.authN) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushNamed('/');
    });
  } else if (user.createComplete && !user.authN) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // When authN == false, remove all pages in stack except /splash
      // SplashPage is where authN conditional routing logic is held
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', ModalRoute.withName('/splash'));
    });
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    authNav(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15),
                child: Text(
                  'Lexity.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
