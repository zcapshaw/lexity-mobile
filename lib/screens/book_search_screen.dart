import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:lexity_mobile/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:lexity_mobile/models/book.dart';
import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/screens/add_book_screen.dart';

enum Origin { fab, navSearch }

class BookSearchScreen extends StatefulWidget {
  BookSearchScreen({this.origin});

  final Origin origin;

  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final String illustration = 'assets/undraw_reading_time_gvg0.svg';
  String queryText = '';
  User user;

  @override
  void initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = context.bloc<AuthenticationBloc>().state.user;
  }

  //This async function returns a List of Books from the API response
  Future<List<Book>> _fetchResults() async {
    //fetch google books results based on queryText
    final data = await http.get(
        'https://api.lexity.co/search/private/books?userId=${user.id}&searchText=$queryText',
        headers: {
          'access-token': '${user.accessToken}',
        });

    //declare an empty list of Books
    var books = <Book>[];

    if (data.statusCode == 200) {
      //decode JSON from API and store in a new variable
      var jsonData = json.decode(data.body) as List<Map<String, dynamic>>;

      // Populate the books array by looping over jsonData
      // and creating a Book for each element
      for (var b in jsonData) {
        // handle books that come back from Google with missing data
        final cover =
            b['cover'] != null ? b['cover']['thumbnail'] as String : '';
        final subtitle = b['subtitle'] as String ?? '';
        final inUserList = b['inUserList'] as bool;
        final userRead = b['userRead'] as bool;
        final title = b['title'] as String ?? '';
        final authors = b['authors'] as List<String> ?? <String>[''];
        final description = b['description'] as String ?? '';
        final categories = b['categories'] as List<String> ?? <String>[''];
        final googleId = b['googleId'] as String;
        //construct a Book object and add it to the books array
        final book = Book(
            title: title,
            subtitle: subtitle,
            authors: authors,
            inUserList: inUserList,
            userRead: userRead,
            thumbnail: cover,
            categories: categories,
            description: description,
            googleId: googleId);

        books.add(book);
      }
    } else {
      print(data.statusCode);
      print(data.reasonPhrase);
    }
    return books;
  }

  void _createBook(Book book) async {
    final googleId = book.googleId;

    final response = await http.post(
      'https://api.lexity.co/book/create/$googleId',
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body) as Map<String, dynamic>;

      await Navigator.push<Map>(
        context,
        MaterialPageRoute(
          builder: (context) => AddBookScreen(
            book: book,
            bookId: responseJson['id'] as String,
          ),
        ),
      );

      print(responseJson['id']);
    }
  }

  String _modifiedAuthorText(Book book) {
    var author = book.authorsAsString ?? '';
    if (book.inUserList && book.userRead) {
      author = '$author • Previously read';
    } else if (book.inUserList) {
      author = '$author • On my list';
    }
    return author;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(20),
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
                        const SizedBox(
                          width: 5,
                        ),
                        // this button should not be shown on main_screen under
                        // search it should only be shown in the add a book flow
                        if (widget.origin == Origin.fab)
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
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
                        itemCount: snapshot.data.length as int,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                  title: Text(snapshot
                                      .data[index].titleWithSubtitle as String),
                                  subtitle: Text(_modifiedAuthorText(
                                      snapshot.data[index] as Book)),
                                  leading: Image.network(
                                      snapshot.data[index].thumbnail as String),
                                  onTap: () {
                                    print(snapshot.data[index].title);
                                    print(snapshot.data[index].subtitle == '');
                                    _createBook(snapshot.data[index] as Book);
                                  }),
                              const Divider(),
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
    });
  }
}

class AddBookBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
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
