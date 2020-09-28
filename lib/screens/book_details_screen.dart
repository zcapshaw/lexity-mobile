import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/blocs/blocs.dart';

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
          print(state.book.cover == '');
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
                  buildCoverArt(state?.book?.cover, coverArtHeight),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildTitle(state.book.title ?? '', context),
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
                  child: Container(
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

  Widget buildTitle(text, context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
