import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lexity_mobile/components/image_button.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:uuid/uuid.dart';

import '../blocs/blocs.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import '../utils/utils.dart';

class BookDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthenticationBloc>().state.user;
    final screenHeight = MediaQuery.of(context).size.height;
    final coverArtHeight = screenHeight * 0.4;

    void _updateBookType(ListedBook book, String newType) {
      var updatedBook = book.clone()..changeType = newType;
      context
          .bloc<ReadingListBloc>()
          .add(ReadingListUpdated(updatedBook, user));
      //TODO if we determine using ReadingListUpdated event works, delete below line
      // context.bloc<ReadingListBloc>().add(UpdateBookType(book, user, newType));
      context.bloc<BookDetailsCubit>().closeBookDetails();
      Navigator.pop(context);
    }

    void _addReco(BuildContext context, ListedBook book) async {
      final result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => const AddRecoScreen(),
        ),
      );

      var recoSource = result != null ? result['recoSource'] as String : null;
      var recoText = result != null ? result['recoText'] as String : null;
      var sourceTwitterId =
          result != null ? result['sourceTwitterId'] as int : null;
      var recoTwitterScreenName =
          result != null ? result['recoTwitterScreenName'] as String : null;
      var sourceImg = result != null ? result['sourceImg'] as String : null;
      var sourceTwitterVerified =
          result != null ? result['sourceTwitterVerified'] as bool : null;

      final reco = Note(
        id: Uuid().v4(),
        comment: recoText,
        sourceName: recoSource,
        sourceTwitterId: sourceTwitterId,
        sourceTwitterScreenName: recoTwitterScreenName,
        sourceImg: sourceImg,
        sourceTwitterVerified: sourceTwitterVerified,
        created: DateTime.now().millisecondsSinceEpoch,
      );

      context.bloc<ReadingListBloc>().add(RecoAdded(book, user, reco));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              child: const CircularProgressIndicator(),
            );
          } else if (state.book != null) {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: <Widget>[
                  buildCoverArt(state.book.cover ?? '', coverArtHeight),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildTitle(state.book.titleWithSubtitle, context),
                        buildAuthors(state.book.authorsAsString, context),
                        buildGenre(state.book.primaryGenre),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if (state is BookDetailsWantToRead)
                              ActionButton(
                                icon: Icons.play_arrow,
                                labelText: 'Start Reading',
                                callback: () =>
                                    _updateBookType(state.book, 'READING'),
                              ),
                            if (state is BookDetailsFinished)
                              ActionButton(
                                icon: Icons.replay,
                                labelText: 'Read Again',
                                callback: () =>
                                    _updateBookType(state.book, 'READING'),
                              ),
                            if (state is BookDetailsReading)
                              ActionButton(
                                icon: Icons.done,
                                labelText: 'Mark Finished',
                                callback: () =>
                                    _updateBookType(state.book, 'READ'),
                              ),
                            if (state is BookDetailsUnlisted)
                              ActionButton(
                                icon: Icons.add,
                                labelText: 'Add To My List',
                                callback: () {},
                              ),
                            ActionButton(
                              icon: CupertinoIcons.text_badge_plus,
                              labelText: 'Add Note',
                              key: TestKeys.addNoteButton,
                              callback: () {
                                Navigator.push<void>(
                                    context, AddNoteScreen.route());
                              },
                            ),
                            ActionButton(
                              icon: CupertinoIcons.text_bubble_fill,
                              labelText: 'Add Reco',
                              callback: () {
                                _addReco(context, state.book);
                              },
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Divider(),
                        ),
                        if (state.book.description != null)
                          ExpandableDescription(
                            description: state.book.description,
                            title: 'Description',
                          ),
                        buildNotes(state.notes, user, context, state.book),
                        buildRecos(state.recos, user, context, state.book),
                        buildLinks(context, state.book),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Oops. Something went wrong.'));
          }
        },
      ),
    );
  }

  Widget buildCoverArt(String imageUrl, double height) {
    return imageUrl == ''
        //handle empty image url from Google API
        ? const SizedBox(
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
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          );
  }

  Widget buildTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Widget buildAuthors(String authors, BuildContext context) {
    return Text(
      authors,
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  Widget buildGenre(String genre) {
    return genre == null || genre == ''
        ? const SizedBox.shrink()
        : Padding(
            key: TestKeys.bookDetailsGenreChip,
            padding: const EdgeInsets.only(top: 10.0),
            child: Chip(
              label: Text(genre.toUpperCase()),
              backgroundColor: Colors.teal[700],
              labelPadding: const EdgeInsets.symmetric(horizontal: 10),
              labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          );
  }

  Widget buildNotes(
      List<Note> notes, User user, BuildContext context, ListedBook book) {
    return notes.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      const ListTileHeaderText('My Notes'),
                      TwitterShareButton(notes),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var note in notes)
                      NoteView(
                        comment: note.comment ?? '',
                        created: note.created != null
                            ? formatTime(note.created)
                            : '',
                        noteId: note.id ?? '',
                        noteSrcImg: note.sourceImg,
                        userImg: user.profileImg,
                        deleteCallback: (String noteId) {
                          // emit event to delete the note from reading list
                          context
                              .bloc<ReadingListBloc>()
                              .add(NoteDeleted(noteId, book, user));
                        },
                        editCallback: (String noteId, String comment) {
                          Navigator.push<Map>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNoteScreen(
                                noteId: noteId,
                                noteText: comment,
                              ),
                            ),
                          );
                        },
                        sourceName: note.sourceName,
                        isReco: note.isReco,
                      ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget buildRecos(
      List<Note> notes, User user, BuildContext context, ListedBook book) {
    return notes.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      const ListTileHeaderText('Recos'),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var note in notes)
                      NoteView(
                        comment: note.comment ?? '',
                        created: note.created != null
                            ? formatTime(note.created)
                            : '',
                        noteId: note.id ?? '',
                        noteSrcImg: note.sourceImg,
                        userImg: user.profileImg,
                        deleteCallback: (String noteId) {
                          // emit event to delete the note from reading list
                          context
                              .bloc<ReadingListBloc>()
                              .add(NoteDeleted(noteId, book, user));
                        },
                        editCallback: (String noteId, String comment) {
                          Navigator.push<Map>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNoteScreen(
                                noteId: noteId,
                                noteText: comment,
                              ),
                            ),
                          );
                        },
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

Widget buildLinks(BuildContext context, ListedBook book) {
  final urlLauncher = UrlLauncher();
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              const ListTileHeaderText('Find a copy'),
            ],
          ),
        ),
        ImageButton(
          imageFileName: 'assets/google_logo.svg',
          callback: () async =>
              await urlLauncher.launchInWebViewOrVC(book.googleLink),
          isSVG: true,
        ),
        ImageButton(
          imageFileName: 'assets/amazon_logo.svg',
          callback: () async => await urlLauncher.launchInWebViewOrVC(
              'https://www.amazon.com/s?k=${book.isbn}+${book.uriEncodedTitle}'),
          isSVG: true,
        ),
      ],
    ),
  );
}

class TwitterShareButton extends StatelessWidget {
  TwitterShareButton(this.notes);

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          context.bloc<NotesCubit>().loadNotes(notes);
          Navigator.push<void>(context, SelectNotesScreen.route());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const FaIcon(
              FontAwesomeIcons.twitter,
              size: 16,
              color: Colors.lightBlueAccent,
            ),
            Text('  Share Notes', style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
      ),
    );
  }
}

class ExpandableDescription extends StatelessWidget {
  ExpandableDescription({this.title, this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpandablePanel(
          header: ListTileHeaderText(title),
          collapsed: ExpandableButton(
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
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
                    'p': Style(
                      padding: const EdgeInsets.only(top: 10),
                      margin: const EdgeInsets.only(top: 10),
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
                'p': Style(
                  padding: const EdgeInsets.only(top: 10),
                  margin: const EdgeInsets.only(top: 10),
                )
              },
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Divider(),
        ),
      ],
    );
  }
}
