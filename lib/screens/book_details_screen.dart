import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
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
      ),
      body: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          if (state is BookDetailsLoading) {
            return Center(
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
                        buildAuthors(state.book.authors, context),
                        //TODO: add Genre to ListItem model and pass genre in next line
                        buildGenre('Fiction'),
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
                        )
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
    String authorsString = authors.join(', ');

    return Text(
      authorsString,
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  Widget buildGenre(genre) {
    return Padding(
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
}
