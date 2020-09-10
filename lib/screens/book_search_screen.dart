import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:lexity_mobile/screens/add_book_screen.dart';
import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/models/book.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final String illustration = 'assets/undraw_reading_time_gvg0.svg';
  String queryText = '';
  UserModel user;

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = Provider.of<UserModel>(context, listen: false);
  }

  //This async function returns a List of Books from the API response
  Future<List<Book>> _fetchResults() async {
    //fetch google books results based on queryText
    final http.Response data = await http.get(
        'https://api.lexity.co/search/private/books?userId=${user.id}&searchText=$queryText',
        headers: {
          'access-token': '${user.accessToken}',
        });

    //declare an empty list of Books
    List<Book> books = [];

    if (data.statusCode == 200) {
      //decode JSON from API and store in a new variable
      var jsonData = json.decode(data.body);

      //Populate the books array by looping over jsonData and creating a Book for each element
      for (var b in jsonData) {
        //handle books that come back from Google with missing data
        final String cover = b['cover'] != null ? b['cover']['thumbnail'] : '';
        final String subtitle = b['subtitle'] ?? '';
        final bool inUserList = b['inUserList'];
        final bool userRead = b['userRead'];
        String title = b['title'] ?? '';
        String author = b['authors'] != null ? b['authors'][0] : '';

        //construct a Book object and add it to the books array
        Book book = Book(
            title: title,
            subtitle: subtitle,
            author: author,
            inUserList: inUserList,
            userRead: userRead,
            thumbnail: cover,
            googleId: b['googleId']);
        books.add(book);
      }
    } else {
      print(data.statusCode);
      print(data.reasonPhrase);
    }
    return books;
  }

  void _createBook(book) async {
    final String googleId = book.googleId;

    final http.Response response = await http.post(
      'https://api.lexity.co/book/create/$googleId',
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddBookScreen(
            book: book,
            bookId: responseJson['id'],
          ),
        ),
      );

      print(responseJson['id']);
    }
  }

  String _modifiedAuthorText(Book book) {
    String author = book.bookAuthors[0] ?? '';
    if (book.bookInUserList && book.userReadBook) {
      author = '$author • Previously read';
    } else if (book.bookInUserList) {
      author = '$author • On my list';
    }
    return author;
  }

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
                          autocorrect: false,
                          clearButtonMode: OverlayVisibilityMode.editing,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          textInputAction: TextInputAction.search,
                          //TODO: add debouncing to onChange logic
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
                        return Column(
                          children: <Widget>[
                            ListTile(
                                title: Text(
                                    snapshot.data[index].titleWithSubtitle),
                                subtitle: Text(
                                    _modifiedAuthorText(snapshot.data[index])),
                                leading: Image.network(
                                    snapshot.data[index].thumbnail),
                                onTap: () {
                                  _createBook(snapshot.data[index]);
                                }),
                            Divider(),
                          ],
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
