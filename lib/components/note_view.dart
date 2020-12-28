import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NoteView extends StatelessWidget {
  const NoteView(
      {this.comment,
      this.created,
      this.noteId,
      this.deleteCallback,
      this.editCallback,
      this.leadingImg,
      this.isReco,
      this.sourceName});

  final String comment;
  final String created;
  final String noteId;
  final String leadingImg;
  final Function deleteCallback;
  final Function editCallback;
  final bool isReco;
  final String sourceName;

  Future<void> _handleNoteTap(BuildContext context) async {
    final action = await showCupertinoModalPopup<String>(
        context: context, builder: (BuildContext context) => NoteActionSheet());

    if (action == 'delete') {
      deleteCallback(noteId);
    }

    if (action == 'edit') {
      editCallback(noteId, comment);
    }
  }

  String _getInitials() {
    var initials = '';

    if (sourceName != null) {
      //create an array of words, split by spaces in sourceName
      final splitWords = sourceName?.toUpperCase()?.split(' ');

      //populate `initials` with first character of each word, up to 2
      for (var word in splitWords) {
        initials = '$initials${word[0]}';
        if (initials.length >= 2) {
          break;
        }
      }
    }

    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (sourceName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Recommended by $sourceName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                comment == '' ? const SizedBox.shrink() : Text(comment)
              ],
            ),
          ),
          subtitle: Text(created),
          leading: sourceName != null
              ? CircleAvatar(
                  backgroundColor: Colors.grey[600],
                  child: Text(
                    _getInitials(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(leadingImg ?? ''),
                  backgroundColor: Colors.grey[600],
                ),
          onTap: () => _handleNoteTap(context),
        ),
        const Divider(),
      ],
    );
  }
}

class NoteActionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          child: const Text('Edit Note'),
          onPressed: () => Navigator.of(context).pop('edit'),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: const Text('Delete Note'),
          onPressed: () => Navigator.of(context).pop('delete'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
