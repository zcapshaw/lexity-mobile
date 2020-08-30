import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NoteView extends StatelessWidget {
  final String comment;
  final String created;
  final String noteId;
  final Function deleteCallback;
  final Function editCallback;

  const NoteView(
      {this.comment,
      this.created,
      this.noteId,
      this.deleteCallback,
      this.editCallback});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            _handleNoteTap(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    created,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    comment,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
