import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TextInputModal extends StatefulWidget {
  TextInputModal({@required this.callback, this.initialText});

  final Function callback;
  final String initialText;

  @override
  _TextInputModalState createState() => _TextInputModalState();
}

class _TextInputModalState extends State<TextInputModal> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Container(
            child: Icon(
              Icons.maximize,
              size: 36,
              color: Colors.grey[700],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CupertinoTextField(
                autofocus: true,
                autocorrect: true,
                clearButtonMode: OverlayVisibilityMode.never,
                controller: _textController,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                enableInteractiveSelection: true,
                enableSuggestions: true,
                maxLines: 5,
                minLines: 2,
                padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                placeholder: 'Jot down notes about this book',
                suffix: RawMaterialButton(
                  constraints: const BoxConstraints.tightForFinite(),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () => widget.callback(_textController.text),
                  padding: const EdgeInsets.all(15),
                ),
                suffixMode: OverlayVisibilityMode.editing,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
