import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lexity_mobile/blocs/authentication/bloc/authentication_bloc.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import '../services/list_service.dart';

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
  User user;
  ListService get listService => GetIt.I<ListService>();

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = context.bloc<AuthenticationBloc>().state.user;
  }

  void _saveListItem() async {
    final String type = listType;
    final List labels = [];
    final Note note = Note(comment: noteText);
    final Note reco = Note(sourceName: recoSource, comment: recoText);
    final List<Note> notes = [note, reco];

    // Temporary instantiation without image - eventually, user search will provide img if available
    final List newReco = [
      {'sourceName': recoSource, 'sourceImg': null}
    ];

    // Only retain non-null notes objects with text.length > 0
    // E.g. if there are NO notes OR recos, this will return an empty list []
    notes.retainWhere((note) =>
        note.comment != null && note.comment.length > 0 ||
        note.sourceName != null && note.sourceName.length > 0);

    print('notes are $notes');

    ListedBook item = ListedBook(
        userId: user.id,
        bookId: widget.bookId,
        type: type,
        labels: labels,
        notes: notes);

    ListedBook book = ListedBook(
      bookId: widget.bookId,
      title: widget.book.title,
      subtitle: widget.book.subtitle,
      authors: widget.book.authors,
      cover: widget.book.thumbnail,
      description: widget.book.description,
      categories: widget.book.categories,
      type: listType,
      recos: recoSource != null ? newReco : [],
    );

    bookListBloc.addBook(item, book, user.accessToken);
    print('successfully added ${widget.bookId}');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainScreen()));
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
    BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
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
                title: Text(widget.book.titleWithSubtitle),
                subtitle: Text(widget.book.authorsAsString),
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
    });
  }
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
