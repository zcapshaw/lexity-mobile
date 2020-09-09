import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:get_it/get_it.dart';
import 'package:expandable/expandable.dart';

import '../models/book.dart';
import '../models/user.dart';
import '../models/note.dart';
import '../models/list_item.dart';
import '../components/list_tile_header_text.dart';
import '../components/action_button.dart';
import '../components/note_view.dart';
import '../components/text_input_modal.dart';
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
  String listId;
  String actionText = 'Start Reading';
  String nextType = 'READING';
  IconData actionIcon = Icons.play_arrow;
  ListService get listService => GetIt.I<ListService>();

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = Provider.of<UserModel>(context, listen: false);
  }

  Future<Book> _getListItemDetail() async {
    Book book;

    final response = await listService.getListItemDetail(
        user.accessToken, user.id, widget.bookId);

    if (!response.error) {
      var bookJson = jsonDecode(response.data) as Map;
      var notesJson = bookJson['notes'] ?? [];

      htmlDescription = bookJson['description'];

      List<Note> notesArray = [];
      for (var n in notesJson) {
        Note note = Note(
          comment: n['comment'] ?? '',
          created: n['created'],
          id: n['id'],
          sourceName: n['sourceName'],
          isReco: (n['sourceName'] != null),
        );
        notesArray.add(note);
        print(note.isReco);
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

      //sets action button icon and text based on listType
      switch (bookJson['type']) {
        case "TO_READ":
          actionText = 'Start Reading';
          actionIcon = Icons.play_arrow;
          nextType = 'READING';
          break;
        case "READING":
          actionText = 'Mark As Finished';
          actionIcon = Icons.done;
          nextType = 'READ';
          break;
        case "READ":
          actionText = 'Read Again';
          actionIcon = Icons.replay;
          nextType = 'READING';
          break;
        default:
          actionText = 'Start Reading';
          actionIcon = Icons.play_arrow;
      }

      book = Book(
        title: bookJson['title'],
        subtitle: bookJson['subtitle'],
        author: bookJson['authors'][0],
        thumbnail: bookJson['cover'],
        listId: bookJson['listId'],
        genre: genre,
        listType: bookJson['type'],
      );
      listId = book.listId;
    } else {
      print(response.errorCode);
      print(response.errorMessage);
    }
    return book;
  }

  void _addNote(text) async {
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

  void _deleteNote(context, noteId) async {
    final response =
        await listService.deleteNote(user.accessToken, user.id, listId, noteId);

    if (response.error) {
      print(response.errorCode);
      print(response.errorMessage);
    } else {
      print('successfully deleted $noteId');

      setState(() {
        //triggers a refresh of the detail page
        notes = [];
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.grey[600],
        content: Text('Note deleted.'),
        duration: Duration(seconds: 1),
      ));
    }
  }

  void _editNote(noteId, comment) {
    print(noteId);
    print(comment);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext context) => TextInputModal(
        callback: (updatedText) async {
          Object updatedNote = {
            'userId': user.id,
            'listId': listId,
            'note': {'id': noteId, 'comment': updatedText}
          };

          final response =
              await listService.updateNote(user.accessToken, updatedNote);

          if (response.error) {
            print(response.errorCode);
            print(response.errorMessage);
          } else {
            print('successfully updated $noteId');
            setState(() {
              //triggers a refresh of the detail page
              notes = [];
            });
          }

          Navigator.pop(context);
        },
        initialText: comment,
      ),
    ).then((value) {
      setState(() {
        //triggers a refresh of the detail page
        notes = [];
      });
    });
  }

  void _updateType() async {
    final response = await listService.updateListItemType(
        user.accessToken, user.id, widget.bookId, nextType);
    if (response.error) {
      print(response.errorCode);
      print(response.errorMessage);
    } else {
      print('successfully updated type');
      //pass 'true' so the snackbar message will show on the previous screen
      Navigator.pop(context, true);
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
                                  icon: actionIcon,
                                  labelText: actionText,
                                  callback: () => _updateType(),
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
                                          TextInputModal(
                                        callback: _addNote,
                                      ),
                                    ).then((value) {
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
                            ExpandableDescription(
                              description: htmlDescription,
                              title: 'Description',
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
                                    noteId: note.id,
                                    leadingImg: user.profileImg,
                                    deleteCallback: _deleteNote,
                                    editCallback: _editNote,
                                    sourceName: note.sourceName,
                                    isReco: note.isReco,
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

class ExpandableDescription extends StatelessWidget {
  final String title;
  final String description;

  ExpandableDescription({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: ListTileHeaderText(title),
      collapsed: ExpandableButton(
        child: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height * 1.5));
          },
          blendMode: BlendMode.dstIn,
          child: Container(
            height: 100,
            child: Html(
              data: description,
              style: {
                "p": Style(
                  padding: EdgeInsets.only(top: 10),
                  margin: EdgeInsets.only(top: 10),
                ),
              },
            ),
          ),
        ),
      ),
      expanded: ExpandableButton(
        child: Html(
          data: description,
          style: {
            "p": Style(
              padding: EdgeInsets.only(top: 10),
              margin: EdgeInsets.only(top: 10),
            )
          },
        ),
      ),
    );
  }
}
