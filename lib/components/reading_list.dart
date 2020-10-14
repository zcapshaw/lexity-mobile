import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lexity_mobile/screens/book_details_screen.dart';
import '../blocs/blocs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reorderable_list_w_physics.dart';
import 'list_tile_header.dart';
import 'list_tile_item.dart';
import '../models/listed_book.dart';
import '../models/user.dart';
import '../components/empty_list_illustration.dart';

class ReadingList extends StatefulWidget {
  final List<String> includedTypes;
  final bool enableSwipeRight;
  final bool enableHeaders;
  // used for conditional indexing on homescreen (when there's no READ list)
  final bool isHomescreen;

  ReadingList({
    @required this.includedTypes,
    this.enableSwipeRight = true,
    this.enableHeaders = true,
    this.isHomescreen = false,
  });

  @override
  _ReadingListState createState() => _ReadingListState();
}

class _ReadingListState extends State<ReadingList> {
  User user;
  final ScrollController reorderScrollController = ScrollController();

  @override
  initState() {
    super.initState();
    // assign user for access to UserModel methods
    user = context.bloc<AuthenticationBloc>().state.user;
  }

  void _updateType(ListedBook book) async {
    ListedBook updatedBook = book.clone();
    switch (book.type) {
      case 'READING':
        {
          updatedBook.changeType = 'READ';
        }
        break;
      case 'TO_READ':
        {
          updatedBook.changeType = 'READING';
        }
        break;
      default:
        {
          updatedBook.changeType = 'TO_READ';
        }
        break;
    }
    context.bloc<ReadingListBloc>().add(ReadingListUpdated(updatedBook));
  }

  Future<bool> _promptUser(DismissDirection direction, ListedBook book) async {
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text("Are you sure you want to delete ${book.title}?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Delete"),
                onPressed: () {
                  // Dismiss the dialog and also dismiss the swiped item
                  context.bloc<ReadingListBloc>().add(ReadingListDeleted(book));
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  // Dismiss the dialog but don't dismiss the swiped item
                  return Navigator.of(context).pop(false);
                },
              )
            ],
          ),
        ) ??
        false; // In case the user dismisses the dialog by clicking away from it
  }

  _navigateToBookDetails(BuildContext context, ListedBook book, int listItemIndex) async {
    //dispatch a function to update BookDetailsCubit state
    print(book.notes);
    context.bloc<BookDetailsCubit>().viewBookDetails(book);
    //Navigate to book details screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => BookDetailScreen(book, listItemIndex),
        builder: (context) => BookDetailsScreen(),
      ),
    );
    //reset state upon return

    setState(() {});
    if (result == true) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("Successfully updated list."),
          backgroundColor: Colors.grey[600],
          duration: Duration(seconds: 1),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: BlocBuilder<ReadingListBloc, ReadingListState>(builder: (context, state) {
        if (state is ReadingListLoadInProgress) {
          return CircularProgressIndicator();
        } else if (state is ReadingListLoadSuccess) {
          final readingList = state.readingList;
          return Column(
            children: <Widget>[
              Flexible(
                child: RefreshIndicator(
                  //TODO: The refreshReadingList Future<void> doesn't return once the reading list is confirmed refreshed, as it should
                  onRefresh: () => refreshReadingList(context),
                  child: CustomReorderableListView(
                    scrollController: reorderScrollController,
                    scrollDirection: Axis.vertical,
                    onReorder: (oldIndex, newIndex) => context.bloc<ReadingListBloc>().add(
                        ReadingListReordered(oldIndex, newIndex,
                            isHomescreen: widget.isHomescreen)),
                    children: List.generate(readingList.length, (index) {
                      if (readingList[index] != null) {
                        if (readingList[index] is ListedBookHeader &&
                            widget.enableHeaders &&
                            widget.includedTypes.contains(readingList[index].type)) {
                          return ListTileHeader(
                            type: readingList[index].type,
                            key: UniqueKey(),
                          );
                        } else if (readingList[index] is ListedBook &&
                            readingList[index] is! ListedBookHeader &&
                            widget.includedTypes.contains(readingList[index].type)) {
                          return ListTileItem(
                            item: readingList[index],
                            tileIndex: index,
                            enableSwipeRight: widget.enableSwipeRight,
                            onPressTile: _navigateToBookDetails,
                            deletePrompt: _promptUser,
                            typeChangeAction: _updateType,
                            key: ValueKey(readingList[index].bookId),
                          );
                        } else {
                          return Container(key: UniqueKey(), height: 0, width: 0);
                        }
                      }
                    }),
                  ),
                ),
              ),
              BlocBuilder<StatsCubit, StatsState>(builder: (context, state) {
                // conditionally show empty list illustration if reading list is empty
                if (state is StatsLoadInProgress) {
                  return Container();
                } else if (state is StatsLoadSuccess) if (widget.isHomescreen &&
                    state.readingCount == 0 &&
                    state.toReadCount == 0) {
                  return EmptyListIllustration(widget.isHomescreen);
                } else if (!widget.isHomescreen && state.readCount == 0) {
                  return EmptyListIllustration(widget.isHomescreen);
                } else {
                  return SizedBox.shrink();
                }
              }),
            ],
          );
        } else {
          return Container();
        }
      }),
    );
  }

  // Method to provide required Future<void> to onRefreshed()
  // As mentioned in TODO, the event trigger is not an async process,
  // So the refresh indicator doesn't work exactly right - to be fixed
  Future<void> refreshReadingList(BuildContext context) async {
    BlocProvider.of<ReadingListBloc>(context).add(ReadingListRefreshed());
  }
}
