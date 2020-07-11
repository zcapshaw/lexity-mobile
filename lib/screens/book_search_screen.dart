import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final String illustration = 'assets/undraw_reading_time_gvg0.svg';
  String queryText = '';

  //This async function returns a List of BookTiles from the API response
  Future<List<BookTile>> _fetchResults() async {
    final String user = 'Users/74763';
    final userJwt = DotEnv().env['USER_JWT'];

    //fetch google books results based on queryText
    final http.Response data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/search/private/books?userId=$user&searchText=$queryText',
        headers: {
          'user-jwt': '$userJwt',
        });

    //declare an empty list of BookTiles
    List<BookTile> books = [];

    if (data.statusCode == 200) {
      //decode JSON from API and store in a new variable
      var jsonData = json.decode(data.body);

      //Populate the books array by looping over jsonData and creating a BookTile for each element
      for (var b in jsonData) {
        //handle books that come back from Google with no cover data
        if (b.containsKey('cover')) {
          BookTile book = BookTile(b['title'], b['authors'[0]],
              b['cover']['thumbnail'], b['inUserList']);
          books.add(book);
        } else {
          BookTile book =
              BookTile(b['title'], b['authors'[0]], null, b['inUserList']);
          books.add(book);
        }
      }

      print(books.length);
    } else {
      print(data.statusCode);
      print(data.reasonPhrase);
    }
    return books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          textInputAction: TextInputAction.search,
                          onChanged: (text) {
                            setState(() {
                              queryText = text;
                            });
                          },
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
              Expanded(
                child: FutureBuilder(
                  future: _fetchResults(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null || queryText == '') {
                      return AddBookBackground();
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(snapshot.data);
                        return ListTile(
                          title: Text(snapshot.data[index].title),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddBookBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
          child: Container(
            child: Text(
              'Pro tip: You can search by title, author, or ISBN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                letterSpacing: 0.4,
                height: 1.5,
              ),
            ),
          ),
        ),
        Container(
          child: Image.asset('assets/undraw_reading_time_gvg0.png'),
        ),
      ],
    );
  }
}

class BookTile {
  final String title;
  final String author;
  final String thumbnail;
  final bool inUserList;

  BookTile(this.title, this.author, this.thumbnail, this.inUserList);
}
