import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/features/book_details/cubit/book_details_cubit.dart';

import 'book_details_view.dart';

class BookDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookDetailsCubit(),
      child: BookDetailsView(),
    );
  }
}
