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

    print(recoCount);

    if (recoCount > 0) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                'Recommended by',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            Row(
              children: <Widget>[
                for (var r in recos) RecoImg(r['sourceImg'], r['sourceName']),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class RecoImg extends StatelessWidget {
  final String sourceName;
  final sourceImg; // not typed, as can be String OR null
  final double diameter = 35;

  RecoImg(this.sourceImg, this.sourceName);

  Widget _buildInitialsReco(String sourceName) {
    RegExp toInitials = RegExp('\\B[A-Za-z]');
    String allInitials = sourceName.toUpperCase().replaceAll(toInitials, '');
    String initials = allInitials.replaceAll(RegExp('\\s'), '').substring(0, 2);

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Text(initials),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sourceImg == null) {
      return _buildInitialsReco(sourceName);
    } else {
      return Container(
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
