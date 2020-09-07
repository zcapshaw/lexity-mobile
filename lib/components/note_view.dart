import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NoteView extends StatelessWidget {
  final String comment;
  final String created;
  final String noteId;
  final String leadingImg;
  final Function deleteCallback;
  final Function editCallback;
  final bool isReco;
  final String sourceName;

  const NoteView(
      {this.comment,
      this.created,
      this.noteId,
      this.deleteCallback,
      this.editCallback,
      this.leadingImg,
      this.isReco,
      this.sourceName});

  _handleNoteTap(BuildContext context) async {
    final action = await showCupertinoModalPopup(
        context: context, builder: (BuildContext context) => NoteActionSheet());

    if (action == 'delete') {
      deleteCallback(context, noteId);
    }

    if (action == 'edit') {
      editCallback(noteId, comment);
    }
  }

  String _getInitials() {
    //create an array of words, split by spaces in sourceName
    List<String> splitWords = sourceName.toUpperCase().split(' ');
    String initials = '';

    //populate `initials` with first character of each word, up to 2
    for (var word in splitWords) {
      initials = initials + '${word[0]}';
      if (initials.length >= 2) {
        break;
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
                if (isReco)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Recommended by $sourceName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                comment == '' ? SizedBox.shrink() : Text(comment)
              ],
            ),
          ),
          subtitle: Text(created),
          leading: isReco
              ? CircleAvatar(
                  backgroundColor: Colors.grey[600],
                  child: Text(
                    _getInitials(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(leadingImg),
                  backgroundColor: Colors.grey[600],
                ),
          onTap: () => _handleNoteTap(context),
        ),
        Divider(),
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
          child: Text('Edit Note'),
          onPressed: () => Navigator.of(context).pop('edit'),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: Text('Delete Note'),
          onPressed: () => Navigator.of(context).pop('delete'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
