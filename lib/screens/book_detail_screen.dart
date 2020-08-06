import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Book Detail Screen',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        body: SafeArea(
          child: Container(
            child: null,
          ),
        ));
  }
}
