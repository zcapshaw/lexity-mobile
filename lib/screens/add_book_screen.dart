import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:lexity_mobile/models/user.dart';
import 'package:lexity_mobile/models/note.dart';
import 'package:lexity_mobile/components/list_tile_header_text.dart';
import 'package:lexity_mobile/screens/main_screen.dart';
import 'package:lexity_mobile/models/book.dart';

part 'add_book_screen.g.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key key, this.book, this.bookId}) : super(key: key);

  final Book book;
  final String bookId;

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  List<bool> _listStatus = [true, false, false];
  String listType = 'TO_READ';
  String noteText = '';
  UserModel user;

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = Provider.of<UserModel>(context, listen: false);
  }

  void _saveListItem() async {
    final String type = listType;
    final List labels = [];
    final Note note = Note(comment: noteText);
    final jsonNote = note.toJson();
    final List notes = [jsonNote];
    ListItem item;

    //fixing a bug where empty string notes were getting created every time you add a book
    if (noteText == '') {
      item = ListItem(
          userId: user.id, bookId: widget.bookId, type: type, labels: labels);
    } else {
      item = ListItem(
          userId: user.id,
          bookId: widget.bookId,
          type: type,
          labels: labels,
          notes: notes);
    }
    final jsonItem = _$ListItemToJson(item);
    print(jsonItem);
    final http.Response res = await http.post(
      'https://stellar-aurora-280316.uc.r.appspot.com/list/add',
      headers: {
        'access-token': '${user.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(jsonItem),
    );
    if (res.statusCode == 200) {
      print('successfully added ${widget.bookId}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListTileHeaderText('Add to list'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                      child: ToggleButtons(
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                'Want to read',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                'Reading',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          Container(
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
                        constraints:
                            BoxConstraints(minHeight: 30, minWidth: 110),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            AddNoteTile(
              onTextChange: (text) {
                setState(() {
                  noteText = text;
                });
                print(noteText);
              },
            ),
          ],
        ),
      ),
    );
  }
}

@JsonSerializable()
class ListItem {
  ListItem({this.userId, this.bookId, this.type, this.labels, this.notes});

  String userId;
  String bookId;
  String type;
  List labels;
  List notes;

  Map<String, dynamic> toJson() => _$ListItemToJson(this);
}

class AddNoteTile extends StatelessWidget {
  final Function onTextChange;

  AddNoteTile({this.onTextChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTileHeaderText('Add a note'),
          TextField(
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Jot down any thoughts here'),
            maxLines: null,
            onChanged: (text) => onTextChange(text),
          ),
        ],
      ),
    );
  }
}
