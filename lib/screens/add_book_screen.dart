import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../blocs/blocs.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key key, this.book, this.bookId}) : super(key: key);

  final Book book;
  final String bookId;

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final List<bool> _listStatus = [true, false, false];
  String listType = 'TO_READ';
  String noteText;
  String recoSource;
  String recoText;
  String recoTwitterScreenName;
  String sourceImg;
  int sourceTwitterId;
  bool sourceTwitterVerified;

  User user;
  ListService get listService => GetIt.I<ListService>();

  @override
  void initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = context.bloc<AuthenticationBloc>().state.user;
  }

  void _saveListItem(BuildContext context) async {
    final creationDateTime = DateTime.now().millisecondsSinceEpoch;
    final labels = <String>[];
    final note = Note(
      id: Uuid().v4(),
      comment: noteText,
      created: creationDateTime,
    );
    final reco = Note(
        id: Uuid().v4(),
        sourceId: null,
        sourceTwitterId: sourceTwitterId,
        sourceName: recoSource,
        sourceTwitterScreenName: recoTwitterScreenName,
        sourceImg: sourceImg,
        comment: recoText,
        sourceTwitterVerified: sourceTwitterVerified,
        created: creationDateTime);
    final notes = [note, reco];

    // Temporary instantiation without image - eventually, user search will
    // provide img if available
    final newReco = [Note(sourceName: recoSource, sourceImg: null)];

    // Only retain non-null notes objects with text.length > 0
    // E.g. if there are NO notes OR recos, this will return an empty list []
    notes.retainWhere((note) =>
        note.comment != null && note.comment.isNotEmpty ||
        note.sourceName != null && note.sourceName.isNotEmpty);

    final book = ListedBook(
      userId: user.id,
      bookId: widget.bookId,
      title: widget.book.title,
      subtitle: widget.book.subtitle,
      authors: widget.book.authors,
      cover: widget.book.thumbnail,
      description: widget.book.description,
      categories: widget.book.categories,
      type: listType,
      labels: labels,
      notes: notes,
      recos: recoSource != null && recoSource.isNotEmpty ? newReco : [],
    );

    context.bloc<ReadingListBloc>().add(ReadingListAdded(book, user));
    print('successfully added ${widget.bookId}');
    print(book.notes);
    await Navigator.push<Map>(
        context, MaterialPageRoute(builder: (context) => MainScreen()));
  }

  void _addReco(
      BuildContext context, String recoSource, String recoText) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecoScreen(
            recoSource: recoSource,
            recoText: recoText,
            recoTwitterScreenName: recoTwitterScreenName,
            sourceImg: sourceImg,
            sourceTwitterId: sourceTwitterId,
            sourceTwitterVerified: sourceTwitterVerified),
      ),
    );

    setState(() {
      this.recoSource =
          result != null ? result['recoSource'] as String : recoSource;
      this.recoText = result != null ? result['recoText'] as String : recoText;
      sourceTwitterId =
          result != null ? result['sourceTwitterId'] as int : sourceTwitterId;
      recoTwitterScreenName = result != null
          ? result['recoTwitterScreenName'] as String
          : recoTwitterScreenName;
      sourceImg = result != null ? result['sourceImg'] as String : sourceImg;
      sourceTwitterVerified = result != null
          ? result['sourceTwitterVerified'] as bool
          : sourceTwitterVerified;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
                _saveListItem(context);
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(widget.book.titleWithSubtitle),
                subtitle: Text(widget.book.authorsAsString),
                leading: Image.network(widget.book.thumbnail ?? ''),
              ),
              const Divider(),
              Container(
                height: 100,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: ListTileHeaderText('Add to list'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
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
                              for (var i = 0; i < _listStatus.length; i++) {
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
                          constraints: const BoxConstraints(
                              minHeight: 30, minWidth: 110),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              AddRecoTile(
                  recoSource: recoSource ?? '',
                  recoText: recoText ?? '',
                  onPress: _addReco),
              const Divider(),
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
  AddRecoTile({this.recoSource, this.recoText, @required this.onPress});

  final String recoSource;
  final String recoText;
  final Function onPress;
  final String initialText = 'Who suggested this book to you?';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(context, recoSource, recoText),
      behavior: HitTestBehavior.opaque, // makes whole tile clickable
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ListTileHeaderText('Recommended by'),
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(recoSource.isEmpty ? initialText : recoSource,
                      style: Theme.of(context).textTheme.subtitle2),
                ),
              ],
            ),
            Container(
              child: const Icon(Icons.arrow_forward_ios,
                  size: 20, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
