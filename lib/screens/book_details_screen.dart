import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/utils/test_keys.dart';
import 'package:time_formatter/time_formatter.dart';
import '../components/components.dart';

class BookDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double coverArtHeight = screenHeight * 0.4;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            context.bloc<BookDetailsCubit>().closeBookDetails();
          },
        ),
      ),
      body: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          if (state is BookDetailsLoading) {
            return Center(
              key: TestKeys.bookDetailsLoadingSpinner,
              child: CircularProgressIndicator(),
            );
          } else if (state.book != null) {
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
                  buildCoverArt(state.book.cover ?? '', coverArtHeight),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildTitle(state.book.titleWithSubtitle, context),
                        buildAuthors(state.book.authorsAsString, context),
                        //TODO: add Genre to ListItem model and pass genre in next line
                        buildGenre(state.book.primaryGenre),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (state is BookDetailsWantToRead)
                              startReadingButton(),
                            if (state is BookDetailsFinished) readAgainButton(),
                            if (state is BookDetailsReading)
                              markFinishedButton(),
                            if (state is BookDetailsUnlisted) addToListButton(),
                            ActionButton(
                              icon: Icons.comment,
                              labelText: 'Add Note',
                              callback: () {},
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
                        if (state.book.description != null)
                          ExpandableDescription(
                            description: state.book.description,
                            title: 'Description',
                          ),
                        buildNotes(state.book.notes),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Oops. Something went wrong.'));
          }
        },
      ),
    );
  }

  Widget buildCoverArt(imageUrl, height) {
    return imageUrl == ''
        //handle empty image url from Google API
        ? SizedBox(
            height: 80.0,
          )
        : ClipRect(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      imageUrl,
                    )),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 0.85,
                  widthFactor: 1.0,
                  child: Hero(
                    tag: '${imageUrl}__heroTag',
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget buildTitle(title, context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Widget buildAuthors(authors, context) {
    return Text(
      authors,
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  Widget buildGenre(genre) {
    return genre == null || genre == ''
        ? SizedBox.shrink()
        : Padding(
            key: TestKeys.bookDetailsGenreChip,
            padding: const EdgeInsets.only(top: 10.0),
            child: Chip(
              label: Text(genre.toUpperCase()),
              backgroundColor: Colors.teal[700],
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
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
          );
  }

  Widget startReadingButton() {
    return ActionButton(
      icon: Icons.play_arrow,
      labelText: 'Start Reading',
      callback: () {},
    );
  }

  Widget markFinishedButton() {
    return ActionButton(
      icon: Icons.done,
      labelText: 'Mark Finished',
      callback: () {},
    );
  }

  Widget readAgainButton() {
    return ActionButton(
      icon: Icons.replay,
      labelText: 'Read Again',
      callback: () {},
    );
  }

  Widget addToListButton() {
    return ActionButton(
      icon: Icons.add,
      labelText: 'Add To My List',
      callback: () {},
    );
  }

  Widget buildNotes(notes) {
    return notes == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                        // need to add access to user image
                        // from a new bloc
                        // leadingImg: user.profileImg,
                        deleteCallback: () {},
                        editCallback: () {},
                        sourceName: note.sourceName,
                        isReco: note.isReco,
                      ),
                  ],
                ),
              ],
            ),
          );
  }
}

class ExpandableDescription extends StatelessWidget {
  final String title;
  final String description;

  ExpandableDescription({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpandablePanel(
          header: ListTileHeaderText(title),
          collapsed: ExpandableButton(
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(
                    Rect.fromLTRB(0, 0, rect.width, rect.height * 1.5));
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                height: 100,
                child: Html(
                  data: description ?? '',
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
              data: description ?? '',
              style: {
                "p": Style(
                  padding: EdgeInsets.only(top: 10),
                  margin: EdgeInsets.only(top: 10),
                )
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Divider(),
        ),
      ],
    );
  }
}
