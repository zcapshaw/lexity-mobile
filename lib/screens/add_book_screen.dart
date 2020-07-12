import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lexity_mobile/screens/book_search_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:lexity_mobile/screens/home_screen.dart';

part 'add_book_screen.g.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key key, this.book, this.bookId}) : super(key: key);

  final BookTile book;
  final String bookId;

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  //
  List<bool> _listStatus = [true, false, false];
  String listType = 'TO_READ';

  void _saveListItem() async {
    final String userId = 'Users/74763';
    final userJwt = DotEnv().env['USER_JWT'];
    final String type = listType;
    final List labels = [];
    final List notes = [];

    final ListItem item = ListItem(userId, widget.bookId, type, labels, notes);
    final jsonItem = _$ListItemToJson(item);

    final http.Response res = await http.post(
      'https://stellar-aurora-280316.uc.r.appspot.com/list/add',
      headers: {
        'user-jwt': '$userJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(jsonItem),
    );
    if (res.statusCode == 200) {
      print('successfully added ${widget.bookId}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print(res.statusCode);
      print(res.reasonPhrase);
      print(res.body);
    }

    print(jsonEncode(jsonItem));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Book',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _saveListItem();
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.teal[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(widget.book.title),
              subtitle: Text(widget.book.author),
              leading: Image.network(widget.book.thumbnail),
            ),
            Divider(),
            Container(
              height: 100,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 8),
                    child: Text(
                      'Add to list',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                      child: ToggleButtons(
                        children: <Widget>[
                          Container(
                            width: 125,
                            child: Center(
                              child: Text(
                                'Want to read',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          Container(
                            width: 125,
                            child: Center(
                              child: Text(
                                'Reading',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          Container(
                            width: 125,
                            child: Center(
                              child: Text(
                                'Finished',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ],
                        isSelected: _listStatus,
                        onPressed: (int index) {
                          setState(() {
                            //only allows one choice to be selected at a time
                            for (int i = 0; i < _listStatus.length; i++) {
                              _listStatus[i] = i == index;
                            }
                            if (index == 0) {
                              listType = 'TO_READ';
                            } else if (index == 1) {
                              listType = 'READING';
                            } else if (index == 2) {
                              listType = 'READ';
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(4),
                        borderColor: Colors.grey,
                        selectedBorderColor: Colors.teal,
                        selectedColor: Colors.grey[900],
                        constraints: BoxConstraints(
                          minHeight: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

@JsonSerializable()
class ListItem {
  ListItem(this.userId, this.bookId, this.type, this.labels, this.notes);

  String userId;
  String bookId;
  String type;
  List labels;
  //need to update the type of notes to the Note class when we add that
  List notes;

  Map<String, dynamic> toJson() => _$ListItemToJson(this);
}
