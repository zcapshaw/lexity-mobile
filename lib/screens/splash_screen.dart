import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:lexity_mobile/models/user.dart';
import '../components/book_list_bloc.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

bool authenticated; // maintain local authenticated state

void authNav(context) {
  UserModel user = Provider.of<UserModel>(context, listen: true);
  if (authenticated != user.authN && user.createComplete == true) {
    authenticated = user.authN;
    // Refresh the users Book List upon login
    bookListBloc.refreshBackendBookList(user.accessToken, user.id);
    print(
        'User created: ${user.createComplete}, User authenticated: ${user.authN}');
    if (user.createComplete && user.authN) {
      // SchedulerBinding allows for frame transitions AFTER all current transitions are done
      // It's essentially used to prevent conflict errors by awaiting transitions in progress
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
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    authNav(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Center(child: Image.asset('assets/180.png')),
        ),
      ),
    );
  }
}
