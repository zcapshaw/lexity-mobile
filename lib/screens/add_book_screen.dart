import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import '../models/user.dart';
import '../models/note.dart';
import '../models/book.dart';
import '../components/list_tile_header_text.dart';
import '../components/list_tile_text_field.dart';
import './main_screen.dart';
import './add_reco_screen.dart';
import '../services/list_service.dart';

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
  String noteText;
  String recoSource;
  String recoText;
  UserModel user;
  ListService get listService => GetIt.I<ListService>();

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
    final Note reco = Note(sourceName: recoSource, comment: recoText);
    final List notes = [note.toJson(), reco.toJson()];
    ListItem item;

    // Only retain non-null notes objects with text.length > 0
    // E.g. if there are NO notes OR recos, this will return an empty list []
    notes.retainWhere((note) =>
        note['comment'] != null && note['comment'].toString().length > 0 ||
        note['sourceName'] != null && note['sourceName'].toString().length > 0);

    item = ListItem(
        userId: user.id,
        bookId: widget.bookId,
        type: type,
        labels: labels,
        notes: notes);
    final jsonItem = _$ListItemToJson(item);

    final response =
        await listService.addOrUpdateListItem(user.accessToken, jsonItem);

    if (response.error) {
      print(response.errorCode);
      print(response.errorMessage);
    } else {
      print('successfully added ${widget.bookId}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  _addReco(BuildContext context, String recoSource, String recoText) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecoScreen(
            userId: user.id, recoSource: recoSource, recoText: recoText),
      ),
    );

    setState(() {
      this.recoSource = result != null ? result['recoSource'] : recoSource;
      this.recoText = result != null ? result['recoText'] : recoText;
    });
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
            AddRecoTile(
                recoSource: recoSource ?? '',
                recoText: recoText ?? '',
                onPress: _addReco),
            Divider(),
            TextFieldTile(
              headerText: 'Add a note',
              hintText: 'Jot down any thoughts here',
              maxLines: null,
              onTextChange: (text) {
                setState(() {
                  noteText = text;
                });
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

class AddRecoTile extends StatelessWidget {
  final String recoSource;
  final String recoText;
  final Function onPress;
  final String initialText = 'Who suggested this book to you?';

  AddRecoTile({this.recoSource, this.recoText, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(context, recoSource, recoText),
      behavior: HitTestBehavior.opaque, // makes whole tile clickable
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTileHeaderText('Recommended by'),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(recoSource.length == 0 ? initialText : recoSource,
                      style: Theme.of(context).textTheme.subtitle2),
                ),
              ],
            ),
            Container(
              child:
                  Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
