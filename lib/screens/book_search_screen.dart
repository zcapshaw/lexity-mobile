import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final String illustration = 'assets/undraw_reading_time_gvg0.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CupertinoTextField(
                          autofocus: true,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          placeholder: 'Search for books',
                          prefix: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                child: Text(
                  'Pro tip: You can search by title, author, or ISBN.sa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                    letterSpacing: 0.4,
                    height: 1.5,
                  ),
                ),
              ),
              Container(
                  child: Expanded(
                      child: Image.asset('undraw_reading_time_gvg0.png'))),
            ],
          ),
        ),
      ),
    );
  }
}
