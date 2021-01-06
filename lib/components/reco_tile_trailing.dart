import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/models.dart';

class RecoTileTrailing extends StatelessWidget {
  RecoTileTrailing(this.notes);

  final List<Note> notes;
  final int maxRecoRender = 3;

  @override
  Widget build(BuildContext context) {
    var recos = notes.toList()..retainWhere((Note n) => n?.sourceName != null);
    var recoCount = recos.length;
    var recosBeyondMax = recoCount - maxRecoRender;
    var renderRecos =
        recos.sublist(0, recosBeyondMax >= 0 ? maxRecoRender : recoCount);

    if (recos.isNotEmpty) {
      return Container(
        // ignore: lines_longer_than_80_chars
        // TODO: Discuss whether we want to use the below fixed width instead of MainAxisSize.min
        //width: MediaQuery.of(context).size.width * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                'Recommended by',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ),
            Row(
              mainAxisSize:
                  MainAxisSize.min, // Use the minimum amount of space needed
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                for (Note r in renderRecos) RecoImg(r.sourceImg, r.sourceName),
                if (recosBeyondMax > 0 && recosBeyondMax <= 9)
                  RecoImg(null, '+ ${recosBeyondMax.toString()}'),
                if (recosBeyondMax > 9) RecoImg(null, '9 +'),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(height: 0, width: 0); // Don't render if no recos
    }
  }
}

class RecoImg extends StatelessWidget {
  RecoImg(this.sourceImg, this.sourceName);

  final String sourceName;
  final String sourceImg;
  final double diameter = 30;
  final double leftMargin = 3;

  Widget _buildInitialsReco(String sourceName) {
    //create an array of words, split by spaces in sourceName
    var splitWords = sourceName.toUpperCase().split(' ');
    var initials = '';
    // final recoInitialBackgroundColors = [
    //   0xFFb6d1fa, // blue
    //   0xFFe9c0f0, // purple
    //   0xFFfae43c, // yellow
    //   0xFF98e3a0, // green
    //   0xFF98e3e2, // turquoise
    //   0xFFf0c48b, // orange
    // ];
    // var randomColor = (recoInitialBackgroundColors..shuffle()).first;

    //populate `initials` with first character of each word, up to 2
    for (var word in splitWords) {
      initials = '$initials${word[0]}';
      if (initials.length >= 2) {
        break;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: leftMargin),
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        color: Color(0xFF1A6978),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sourceImg == null) {
      return _buildInitialsReco(sourceName);
    } else {
      return Container(
        margin: EdgeInsets.only(left: leftMargin),
        width: diameter,
        height: diameter,
        child: CachedNetworkImage(
          imageUrl: sourceImg,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: imageProvider,
              ),
            ),
          ),
          placeholder: (context, url) => Icon(Icons.account_circle,
              size: diameter, color: Colors.grey[600]),
          placeholderFadeInDuration: Duration.zero,
        ),
      );
    }
  }
}
