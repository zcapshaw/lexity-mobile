import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/screens/screens.dart';

import '../blocs/blocs.dart';
import '../components/empty_list_illustration.dart';
import '../models/listed_book.dart';
import '../models/user.dart';
import 'book_list_bloc.dart';
import 'list_tile_header.dart';
import 'list_tile_item.dart';
import 'reorderable_list_w_physics.dart';

class ReadingList extends StatefulWidget {
  final List<String> includedTypes;
  final bool enableSwipeRight;
  final bool enableHeaders;
  final bool
      isHomescreen; // used for conditional indexing on homescreen (when there's no READ list)

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

  void _updateType(ListedBook book, int oldIndex) async {
    String newType;
    switch (book.type) {
      case 'READING':
        {
          newType = 'READ';
        }
        break;
      case 'TO_READ':
        {
          newType = 'READING';
        }
        break;
      default:
        {
          newType = 'TO_READ';
        }
        break;
    }
    bookListBloc.changeBookType(book, user, oldIndex, newType);
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
                  bookListBloc.deleteBook(book, user);
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
                  onRefresh: () => bookListBloc.refreshBackendBookList(user.accessToken, user.id),
                  child: CustomReorderableListView(
                    scrollController: reorderScrollController,
                    scrollDirection: Axis.vertical,
                    onReorder: (oldIndex, newIndex) =>
                        bookListBloc.reorderBook(user, oldIndex, newIndex, widget.isHomescreen),
                    children: List.generate(readingList.length, (index) {
                      if (readingList[index] != null) {
                        if (readingList[index] is ListItemHeader && widget.enableHeaders) {
                          return ListTileHeader(
                            type: 'READING', // TEMPORARY
                            key: UniqueKey(),
                          );
                        } else if (readingList[index] is ListedBook &&
                            readingList[index] is! ListItemHeader) {
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

              // child: StreamBuilder(
              //   stream: bookListBloc.listBooks, // Stream getter
              //   initialData: [],
              //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              //     return Column(
              //       children: <Widget>[
              //         Flexible(
              //           child: RefreshIndicator(
              //             onRefresh: () => bookListBloc.refreshBackendBookList(
              //                 user.accessToken, user.id),
              //             child: CustomReorderableListView(
              //               scrollController: reorderScrollController,
              //               scrollDirection: Axis.vertical,
              //               onReorder: (oldIndex, newIndex) => bookListBloc.reorderBook(
              //                   user.currentUser,
              //                   oldIndex,
              //                   newIndex,
              //                   widget.isHomescreen),
              //               children: List.generate(snapshot.data.length, (index) {
              //                 if (snapshot.hasData && snapshot.data[index] != null) {
              //                   if (snapshot.data[index] is ListItemHeader &&
              //                       widget.enableHeaders &&
              //                       widget.types
              //                           .contains(snapshot.data[index].headerType)) {
              //                     return ListTileHeader(
              //                       type: snapshot.data[index].type,
              //                       key: UniqueKey(),
              //                     );
              //                   } else if (snapshot.data[index] is ListedBook &&
              //                       snapshot.data[index] is! ListItemHeader &&
              //                       widget.types.contains(snapshot.data[index].type)) {
              //                     return ListTileItem(
              //                       item: snapshot.data[index],
              //                       tileIndex: index,
              //                       enableSwipeRight: widget.enableSwipeRight,
              //                       onPressTile: _navigateToBookDetails,
              //                       deletePrompt: _promptUser,
              //                       typeChangeAction: _updateType,
              //                       key: ValueKey(snapshot.data[index].bookId),
              //                     );
              //                   } else {
              //                     return Container(
              //                         key: UniqueKey(), height: 0, width: 0);
              //                   }
              //                 }
              //               }),
              //             ),
              //           ),
              //         ),
              StreamBuilder(
                  stream: bookListBloc.listCount, // Stream getter
                  initialData: {},
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    // conditionally show empty list illustration if reading list is empty
                    if (widget.isHomescreen &&
                        snapshot.data['READING'] == 0 &&
                        snapshot.data['TO_READ'] == 0) {
                      return EmptyListIllustration(widget.isHomescreen);
                    } else if (!widget.isHomescreen && snapshot.data['READ'] == 0) {
                      return EmptyListIllustration(widget.isHomescreen);
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
            ],
          );
        }
      }),
    );
  }
}
