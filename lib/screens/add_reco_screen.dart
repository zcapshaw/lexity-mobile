import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../components/list_tile_text_field.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../utils/utils.dart';

class AddRecoScreen extends StatefulWidget {
  const AddRecoScreen({Key key, this.recoSource, this.recoText, this.userId})
      : super(key: key);

  final String recoSource;
  final String recoText;
  final String userId; // To be used with lexity and/or twitter search

  @override
  _AddRecoScreenState createState() => _AddRecoScreenState();
}

class _AddRecoScreenState extends State<AddRecoScreen> {
  String recoSource;
  String recoText;
  bool isConnected;
  ListService listService = ListService();
  User user;

  @override
  void initState() {
    recoSource = widget.recoSource;
    recoText = widget.recoText;
    user = context.bloc<AuthenticationBloc>().state.user;
    _isConnected();
    super.initState();
  }

  // Separate helper function, since initState() is NOT async
  void _isConnected() async {
    isConnected = await InternetConnectionTest.isConnected();
  }

  void _recoSourceInput(String text) async {
    print('isConnected:$isConnected');
    final twitterUsers =
        await listService.searchTwitterUsers(user.accessToken, user.id, text);
    final decoded = jsonDecode(twitterUsers.data as String) as List;
    print(decoded);
    setState(() {
      recoSource = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Recos',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              recoSource.isEmpty && recoText.isNotEmpty
                  ? Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red[300],
                      content: const Text('Reco notes require a source.')))
                  : Navigator.pop(context,
                      {'recoSource': recoSource, 'recoText': recoText});
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.teal[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            children: <Widget>[
              TextFieldTile(
                intialValue: recoSource,
                headerText: 'Who recommended this book to you?',
                hintText: 'Type a name',
                maxLines: 1,
                onTextChange: _recoSourceInput,
              ),
              const Divider(),
              TextFieldTile(
                intialValue: recoText,
                headerText: 'Notes',
                hintText: 'Add a note about what they said...',
                maxLines: null,
                onTextChange: (text) {
                  setState(() {
                    recoText = text;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
