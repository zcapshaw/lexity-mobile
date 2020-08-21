import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../models/book.dart';
import '../models/user.dart';
import '../models/note.dart';
import '../components/list_tile_header_text.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({this.bookId});
  final String bookId;

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  UserModel user;
  String htmlDescription = '';
  List<Note> notes = [];

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = Provider.of<UserModel>(context, listen: false);
  }

  Future<Book> _getListItemDetail() async {
    Book book;

    final http.Response data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/detail/?userId=${user.id}&bookId=${widget.bookId}',
        headers: {
          'access-token': '${user.accessToken}',
        });

    if (data.statusCode == 200) {
      var bookJson = jsonDecode(data.body) as Map;
      var notesJson = bookJson['notes'];

      htmlDescription = bookJson['description'];

      List<Note> notesArray = [];
      for (var n in notesJson) {
        Note note = Note(n['comment']);
        notesArray.add(note);
      }

      notes.addAll(notesArray);

      //Grabs the first key from the categories object and strips off parens and capitalizes text
      String genre = bookJson['categories'][0]
          .keys
          .toString()
          .replaceAll(new RegExp('([()])'), "")
          .toUpperCase();
      print(bookJson['categories'][0].keys);
      print(notesArray);

      book = Book(
        title: bookJson['title'],
        subtitle: bookJson['subtitle'],
        author: bookJson['authors'][0],
        thumbnail: bookJson['cover'],
        genre: genre,
      );
    } else {
      print(data.statusCode);
      print(data.reasonPhrase);
    }
    return book;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double coverArtHeight = screenHeight * 0.4;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          child: FutureBuilder(
            future: _getListItemDetail(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: coverArtHeight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                snapshot.data.thumbnail,
                              )),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: FractionallySizedBox(
                            alignment: Alignment.bottomCenter,
                            heightFactor: 0.85,
                            widthFactor: 1.0,
                            child: Container(
                              child: Image.network(
                                snapshot.data.thumbnail,
                                fit: BoxFit.contain,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                snapshot.data.subtitle == null
                                    ? '${snapshot.data.title}'
                                    : '${snapshot.data.title}: ${snapshot.data.subtitle}',
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                            Text(snapshot.data.author,
                                style: Theme.of(context).textTheme.subtitle1),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Chip(
                                label: Text(snapshot.data.genre),
                                backgroundColor: Colors.teal[700],
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Divider(),
                            ),
                            ListTileHeaderText('Description'),
                            Html(
                              data: htmlDescription,
                              style: {
                                "p": Style(
                                  padding: EdgeInsets.only(top: 10),
                                  margin: EdgeInsets.only(top: 10),
                                )
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Divider(),
                            ),
                            ListTileHeaderText('Notes'),
                            Column(
                              children: <Widget>[
                                for (var note in notes) Text(note.comment),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Oops. Something went wrong'));
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ));
  }
}

class NoteView extends StatelessWidget {
  final String comment;
  final String created;

  const NoteView({this.comment, this.created});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(comment),
    );
  }
}
