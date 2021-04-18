import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lexity_mobile/models/models.dart';
import 'package:lexity_mobile/services/services.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit({@required this.twitterService}) : super(NotesInitial());

  final TwitterService twitterService;

  void toggleSelection(SelectableNote note) {
    var updatedNote = SelectableNote(
        comment: note.comment,
        id: note.id,
        created: note.created,
        selected: !note.selected);

    var updatedNotesArray = (state as NotesLoaded).notes.map((n) {
      if (n.id == note.id) {
        return updatedNote;
      } else {
        return n;
      }
    }).toList();

    emit(
      NotesLoaded(
        updatedNotesArray,
        getTweetsFromNotes(updatedNotesArray),
        getSelectedNotesCount(updatedNotesArray),
      ),
    );
  }

  void loadNotes(List<Note> notes) {
    var selectableNotesArray = <SelectableNote>[];

    //convert notes to SelectableNotes
    for (var note in notes) {
      var sn = SelectableNote(
          comment: note.comment,
          id: note.id,
          created: note.created,
          selected: true);

      selectableNotesArray.add(sn);
    }

    // emit state with plain text notes array for UI
    emit(
      NotesLoaded(
        selectableNotesArray,
        getTweetsFromNotes(selectableNotesArray),
        getSelectedNotesCount(selectableNotesArray),
      ),
    );
  }

  void tweetNotes(List<String> tweets, User user) async {
    print(user.username);
    print(tweets.length);

    try {
      emit(NotesLoading());
      print('loading');
      var res = await twitterService.shareTwitterNotes(
          user.accessToken, user.id, tweets);

      if (res.error == true) {
        // the api returned an error..
        print(res.errorCode);
        print(res.errorMessage);
        emit(TweetFailed());
      } else {
        // the api call was successful
        print('tweet succeeded');
        emit(TweetSucceeded());
      }
    } catch (err) {
      print(err);
      print('tweet failed');
      emit(TweetFailed());
    }

    // add code to talk to an API service
  }

  int getSelectedNotesCount(List<SelectableNote> notes) {
    var selectedCount = notes.where((n) => n.selected == true).toList().length;

    return selectedCount;
  }

  List<String> getTweetsFromNotes(List<SelectableNote> notes) {
    var tweetStringArray = <String>[];

    // filter out unselected notes
    var selectedNotes = List<SelectableNote>.from(notes)
      ..removeWhere((n) => n.selected == false)
      ..toList();

    // create an array of tweet-length strings from notes
    for (var n in selectedNotes) {
      void splitNoteIntoTweets(String str) {
        if (str.length <= 280) {
          // add the comment to an array of strings if it's short enough
          tweetStringArray.add(str);
        } else {
          // split off a tweet sized chunk of text with ellipses
          var splitPoint = str.lastIndexOf(' ', 276);
          var tweet = '${str.substring(0, splitPoint)}...';
          tweetStringArray.add(tweet);

          // recursively call this function on the remaining note text
          splitNoteIntoTweets(str.substring(splitPoint + 1));
        }
      }

      splitNoteIntoTweets(n.comment);
    }

    return tweetStringArray;
  }
}
