import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:lexity_mobile/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:lexity_mobile/models/book.dart';
import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/screens/add_book_screen.dart';

enum Origin { fab, navSearch }

class BookSearchScreen extends StatefulWidget {
  BookSearchScreen({this.origin, this.navCallback});

  final Origin origin;
  final void Function() navCallback;

  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final String illustration = 'assets/undraw_reading_time_gvg0.svg';
  String queryText = '';
  User user;
  FocusNode searchInput;

  @override
  void initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = context.bloc<AuthenticationBloc>().state.user;
    searchInput = FocusNode();

    //autofocus the keyboard if user is coming from FAB click
    if (widget.origin == Origin.fab) {
      searchInput.requestFocus();
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    searchInput.dispose();

    super.dispose();
  }

  //This async function returns a List of Books from the API response
  Future<List<Book>> _fetchResults() async {
    if (user.id != null && queryText.isNotEmpty) {
      List<Book> books;
      //fetch google books results based on queryText
      final data = await http.get(
          'https://api.lexity.co/search/private/books?userId=${user.id}&searchText=$queryText',
          headers: {
            'access-token': '${user.accessToken}',
          });

      if (data.statusCode == 200) {
        try {
          final decoded = json.decode(data.body) as List;
          books = decoded
              .map(
                  (dynamic book) => Book.fromJson(book as Map<String, dynamic>))
              .toList();
        } catch (err) {
          print('Issue generating list of books from search: $err');
        }
      } else {
        print(data.statusCode);
        print(data.reasonPhrase);
      }
      return books;
    }
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
                            focusNode: searchInput,
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
                        FlatButton(
                          onPressed: () {
                            if (widget.origin == Origin.fab) {
                              Navigator.pop(context);
                            } else {
                              widget.navCallback();
                            }
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
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Book>> snapshot) {
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
                                  subtitle: Text(_modifiedAuthorText(
                                      snapshot.data[index])),
                                  leading: Image.network(
                                      snapshot.data[index].thumbnail ?? ''),
                                  onTap: () {
                                    print(snapshot.data[index].title);
                                    print(snapshot.data[index].subtitle == '');
                                    _createBook(snapshot.data[index]);
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
          padding: const EdgeInsets.symmetric(horizontal: 80),
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
        Expanded(
          child: Image.asset('assets/undraw_reading_time_gvg0.png'),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Powered by ',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  letterSpacing: 0.4,
                  height: 1.5,
                ),
              ),
              Text(
                'Google',
                // Style recommended to align with the unavailable Public Sans
                style: GoogleFonts.nunito(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.4,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
