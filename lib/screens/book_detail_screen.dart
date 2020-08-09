import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/book.dart';
import '../models/user.dart';

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
    final http.Response data = await http.get(
        'https://stellar-aurora-280316.uc.r.appspot.com/list/detail/?userId=${user.id}&bookId=${widget.bookId}',
        headers: {
          'access-token': '${user.accessToken}',
        });

    if (data.statusCode == 200) {
      var bookJson = jsonDecode(data.body);
      print(bookJson);

      Book book = Book(
        title: bookJson['title'],
        thumbnail: bookJson['cover'],
      );
      return book;
    } else {
      print(data.statusCode);
      print(data.reasonPhrase);
    }
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
                return Column(
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
                    Expanded(
                      child: Container(color: Colors.white),
                    )
                  ],
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
