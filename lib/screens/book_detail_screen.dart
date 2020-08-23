import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/book.dart';
import '../models/user.dart';
import '../components/list_tile_header_text.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({this.bookId});
  final String bookId;

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  UserModel user;

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
      var bookJson = jsonDecode(data.body);
      print(bookJson);

      book = Book(
        title: bookJson['title'],
        author: bookJson['authors'][0],
        thumbnail: bookJson['cover'],
        description: bookJson['description'],
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
                    physics: ScrollPhysics(
                      // Scroll physics for environments that prevent the scroll
                      // offset from reaching beyond the bounds of the content
                      parent: ClampingScrollPhysics(),
                    ),
                    children: <Widget>[
                      ClipRect(
                        child: Container(
                          height: coverArtHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  snapshot.data.thumbnail,
                                )),
                          ),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
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
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data.title,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              ListTileHeaderText(snapshot.data.author),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Divider(),
                              ),
                              ListTileHeaderText('Description'),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(snapshot.data.description),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Oops. Something went wrong'));
              } else {
                return Expanded(
                  child: Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }
}
