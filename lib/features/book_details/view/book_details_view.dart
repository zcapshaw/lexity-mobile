import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/features/book_details/cubit/book_details_cubit.dart';

class BookDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          return ListView(
            physics: ScrollPhysics(
              // Scroll physics for environments that prevent the scroll
              // offset from reaching beyond the bounds of the content
              parent: ClampingScrollPhysics(),
            ),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildTitle('Title', context),
                  ],
                ),
              ),
            ],
          );
        },
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
