import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../components/list_tile_text_field.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../utils/utils.dart';

class AddRecoScreen extends StatefulWidget {
  const AddRecoScreen(
      {Key key,
      this.recoSource,
      this.recoText,
      this.recoTwitterScreenName,
      this.sourceImg,
      this.sourceTwitterId,
      this.sourceTwitterVerified})
      : super(key: key);

  final String recoSource;
  final String recoText;
  final String recoTwitterScreenName;
  final String sourceImg;
  final int sourceTwitterId;
  final bool sourceTwitterVerified;

  @override
  _AddRecoScreenState createState() => _AddRecoScreenState();
}

class _AddRecoScreenState extends State<AddRecoScreen> {
  String recoSource;
  String recoText;
  String recoTwitterScreenName;
  String sourceImg;
  int sourceTwitterId;
  bool sourceTwitterVerified;
  bool isConnected;
  TwitterService twitterService = TwitterService();
  User user;
  final double twitterImgSize = 50.0;
  Timer _debounce;
  FocusNode recoSourceFocus = FocusNode();
  TextEditingController recoSourceTxtController;
  TextEditingController recoTextTxtController;
  Color recoSourceTxtBackground;

  @override
  void initState() {
    recoSource = widget.recoSource;
    recoText = widget.recoText;
    recoTwitterScreenName = widget.recoTwitterScreenName;
    sourceImg = widget.sourceImg;
    sourceTwitterId = widget.sourceTwitterId;
    sourceTwitterVerified = widget.sourceTwitterVerified;
    recoSourceTxtBackground = widget.sourceTwitterId == null
        ? Colors.transparent
        : const Color(0XFFC0EBFC);
    recoSourceTxtController = TextEditingController(text: widget.recoSource);
    recoTextTxtController = TextEditingController(text: widget.recoText);
    recoSourceFocus.addListener(_onRecoSourceFocusChange);
    user = context.bloc<AuthenticationBloc>().state.user;
    _isConnected();
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    recoSourceFocus.dispose();
    super.dispose();
  }

  // Separate helper function, since initState() is NOT async
  void _isConnected() async {
    isConnected = await InternetConnectionTest.isConnected();
  }

  // called by onTextChange of reco input
  void _debounceRecoSource(String text) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        recoSource = text;

        // While it creates a slight delayed, it's important to have this
        // setState in the debouncer, as it otherwise causes the
        // _twitterUserList() to be called every time there's a keystroke
        // which is highly inefficient and overwhelms the backend
        recoSourceTxtBackground = Colors.transparent;
      });
    });
  }

  void _onTapTwitterUser(
      {int twitterId,
      String twitterName,
      String twitterScreenName,
      String twitterImg,
      bool twitterVerified}) {
    recoSourceFocus.unfocus();
    recoSourceTxtController.text = twitterName;
    setState(() {
      sourceTwitterId = twitterId;
      recoSource = twitterName;
      recoTwitterScreenName = twitterScreenName;
      sourceImg = twitterImg;
      sourceTwitterVerified = twitterVerified;
      recoSourceTxtBackground = const Color(0XFFC0EBFC);
    });
  }

  Future<List> _twitterUserList() async {
    if (recoSourceFocus.hasFocus && recoSource.isNotEmpty) {
      final twitterUsers = await twitterService.searchTwitterUsers(
          user.accessToken, user.id, recoSource);
      final decoded = jsonDecode(twitterUsers.data as String) as List;
      return decoded;
    } else {
      return <String>[];
    }
  }

  void _onRecoSourceFocusChange() {
    if (recoSourceFocus.hasFocus) {
      // By calling setState, the Futurebuilder is called and will build w/
      // recoSourceFocus.hasFocus == true, which will trigger _twitterUserList
      // and query the backend
      setState(() {});
    }
  }

  void _onRecoSourceSubmitted(String text) {
    // If a user clicks in the recoSource text field and instead of choosing a
    // Twitter user (if available), they press the done button the keyboard,
    // this is then treated as pure text input and all twitter association
    // is removed
    setState(() {
      recoTwitterScreenName = null;
      sourceImg = null;
      sourceTwitterId = null;
      sourceTwitterVerified = null;
      recoSourceTxtBackground = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Reco',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: <Widget>[
          // Have to use builder widget to prevent showSnackBar from being
          // called on the same level as the created Scaffold
          Builder(
              builder: (context) => FlatButton(
                    onPressed: () {
                      recoSource == null ||
                              recoSource.isEmpty && recoText.isNotEmpty
                          ? Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red[300],
                              content:
                                  const Text('Reco notes require a source.')))
                          : Navigator.pop(context, {
                              'recoSource': recoSource,
                              'recoText': recoText,
                              'sourceTwitterId': sourceTwitterId,
                              'recoTwitterScreenName': recoTwitterScreenName,
                              'sourceImg': sourceImg,
                              'sourceTwitterVerified': sourceTwitterVerified
                            });
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.teal[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              TextFieldTile(
                focusNode: recoSourceFocus,
                controller: recoSourceTxtController,
                headerText: 'Who recommended this book to you?',
                hintText: 'Type a name or Twitter handle',
                maxLines: 1,
                onTextChange: (text) {
                  _debounceRecoSource(text);
                },
                onSubmitted: _onRecoSourceSubmitted,
                bgColor: recoSourceTxtBackground,
              ),
              const Divider(),
              Expanded(
                child: FutureBuilder(
                    future: _twitterUserList(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (recoSourceFocus.hasFocus) {
                        if (snapshot.data == null ||
                            snapshot.data.isEmpty ||
                            recoSource.isEmpty) {
                          return _buildRecoTextInput();
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(snapshot.data[index]['name']
                                        .toString()),
                                    subtitle: Text(
                                        // ignore: lines_longer_than_80_chars
                                        '@${snapshot.data[index]['screen_name'].toString()}'),
                                    leading: Container(
                                      width: twitterImgSize,
                                      height: twitterImgSize,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(snapshot
                                                  .data[index][
                                                      // ignore: lines_longer_than_80_chars
                                                      'profile_image_url_https']
                                                  .toString() ??
                                              ''),
                                        ),
                                      ),
                                    ),
                                    onTap: () => _onTapTwitterUser(
                                        twitterId: snapshot.data[index]
                                            ['twitter_id'] as int,
                                        twitterName: snapshot.data[index]
                                            ['name'] as String,
                                        twitterScreenName: snapshot.data[index]
                                            ['screen_name'] as String,
                                        twitterImg: snapshot.data[index]
                                                ['profile_image_url_https']
                                            as String,
                                        twitterVerified: snapshot.data[index]
                                            ['verified'] as bool),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        // if !recoSourceFocus.hasFocus
                        return _buildRecoTextInput();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecoTextInput() {
    return TextFieldTile(
      controller: recoTextTxtController,
      headerText: 'Notes',
      hintText: 'Add a note about what they said...',
      maxLines: null,
      onTextChange: (text) {
        setState(() {
          recoText = text;
        });
      },
    );
  }
}
