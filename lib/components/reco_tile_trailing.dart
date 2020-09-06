import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecoTileTrailing extends StatelessWidget {
  final List<dynamic> recos;
  final int maxRecoRender = 3;

  RecoTileTrailing(this.recos);

  @override
  Widget build(BuildContext context) {
    int recoCount = recos.length;
    int recosBeyondMax = recoCount - maxRecoRender;
    List<dynamic> renderRecos =
        recos.sublist(0, recosBeyondMax >= 0 ? maxRecoRender : recoCount);

    if (recos.isNotEmpty) {
      return Container(
        // TODO: Discuss whether we want to use the below fixed width instead of MainAxisSize.min
        //width: MediaQuery.of(context).size.width * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5),
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
                for (var r in renderRecos)
                  RecoImg(r['sourceImg'], r['sourceName']),
                if (recosBeyondMax > 0 && recosBeyondMax <= 9)
                  RecoImg(null, '+${recosBeyondMax.toString()}'),
                if (recosBeyondMax > 9) RecoImg(null, '9+'),
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
  final String sourceName;
  final sourceImg; // not typed, as can be String OR null
  final double diameter = 30;
  final double leftMargin = 3;

  RecoImg(this.sourceImg, this.sourceName);

  Widget _buildInitialsReco(String sourceName) {
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

    return Container(
      margin: EdgeInsets.only(left: leftMargin),
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
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
