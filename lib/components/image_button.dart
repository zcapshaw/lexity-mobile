import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageButton extends StatelessWidget {
  const ImageButton(
      {@required this.imageFileName,
      @required this.callback,
      @required this.isSVG,
      Key key})
      : super(key: key);

  final String imageFileName;
  final void Function() callback;
  final bool isSVG;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: OutlineButton(
          padding: const EdgeInsets.symmetric(vertical: 12),
          borderSide: BorderSide(color: Colors.grey[400]),
          child: isSVG
              ? SvgPicture.asset(imageFileName, height: 35)
              : Image.asset(imageFileName, height: 35),
          onPressed: callback,
        ),
      ),
    );
  }
}
