import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:get_it/get_it.dart';

import '../models/book.dart';
import '../models/user.dart';
import '../models/note.dart';
import '../models/list_item.dart';
import '../components/list_tile_header_text.dart';
import '../services/list_service.dart';

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
  String genre;
  ListService get listService => GetIt.I<ListService>();

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
        Note note = Note(comment: n['comment'] ?? '', created: n['created']);
        notesArray.add(note);
      }

      // adds notes to the list
      // the isEmpty check protects against repeatedly adding dupe notes to the list every time this function is called
      if (notes.isEmpty) {
        notes.addAll(notesArray);
      }

      //Grabs the first key from the categories object and strips off parens and capitalizes text
      if (bookJson['categories'][0] != null) {
        genre = bookJson['categories'][0]
            ?.keys
            .toString()
            .replaceAll(new RegExp('([()])'), "")
            .toUpperCase();
      }

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

  void addNote(text) async {
    final Note note = Note(comment: text);
    final List notes = [note.toJson()];
    ListItem item =
        ListItem(userId: user.id, bookId: widget.bookId, notes: notes);

    final response =
        await listService.addOrUpdateListItem(user.accessToken, item);

    if (response.error) {
      print(response.errorCode);
      print(response.errorMessage);
    } else {
      print('successfully added note');
      Navigator.pop(context);
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
                            if (genre != null)
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ActionButton(
                                  icon: Icons.play_arrow,
                                  labelText: 'Start Reading',
                                  callback: () {},
                                ),
                                ActionButton(
                                  icon: Icons.comment,
                                  labelText: 'Add Note',
                                  callback: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      builder: (BuildContext context) =>
                                          _AddNoteWidget(
                                        callback: addNote,
                                      ),
                                    ).then((value) {
                                      print('refresh state');
                                      setState(() {
                                        //triggers a refresh of the detail page
                                        notes = [];
                                      });
                                    });
                                  },
                                ),
                                ActionButton(
                                  icon: CupertinoIcons.share_up,
                                  labelText: 'Share Book',
                                  callback: () {},
                                ),
                              ],
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTileHeaderText('Notes'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                for (var note in notes)
                                  NoteView(
                                    comment: note.comment,
                                    created: formatTime(note.created),
                                  ),
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

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final Function callback;

  const ActionButton(
      {@required this.icon, this.labelText, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: callback,
            color: Colors.grey[200],
            textColor: Colors.white,
            elevation: 0,
            child: Icon(
              icon,
              size: 24,
              color: Colors.grey[700],
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          ),
        ),
        Text(labelText),
      ],
    );
  }
}

class NoteView extends StatelessWidget {
  final String comment;
  final String created;

  const NoteView({this.comment, this.created});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                created,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                comment,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddNoteWidget extends StatefulWidget {
  final Function callback;
  _AddNoteWidget({@required this.callback});

  @override
  __AddNoteWidgetState createState() => __AddNoteWidgetState();
}

class __AddNoteWidgetState extends State<_AddNoteWidget> {
  String noteText = '';

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Container(
            child: Icon(
              Icons.maximize,
              size: 36,
              color: Colors.grey[700],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CupertinoTextField(
                autofocus: true,
                autocorrect: true,
                clearButtonMode: OverlayVisibilityMode.never,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                enableInteractiveSelection: true,
                enableSuggestions: true,
                maxLines: 5,
                minLines: 2,
                onChanged: (text) {
                  setState(() {
                    noteText = text;
                  });
                },
                padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                placeholder: 'Jot down notes about this book',
                suffix: RawMaterialButton(
                  constraints: BoxConstraints.tightForFinite(),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () => widget.callback(noteText),
                  padding: EdgeInsets.all(15),
                ),
                suffixMode: OverlayVisibilityMode.editing,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
