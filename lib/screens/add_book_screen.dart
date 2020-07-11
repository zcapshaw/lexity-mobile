import 'package:flutter/material.dart';
import 'package:lexity_mobile/screens/book_search_screen.dart';

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
            onPressed: () {},
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
