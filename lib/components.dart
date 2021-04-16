import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/domain/rss_item.dart';

Widget buildTitle(title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
    ),
  );
}

Widget buildTags(String primaryCategory, String label) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        margin: EdgeInsets.only(left: 8),
        color: Colors.green,
        child: Text(
          primaryCategory.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      if (label != null)
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          margin: EdgeInsets.only(left: 8),
          color: Colors.blue,
          child: Text(
            label.toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
    ],
  );
}

Widget buildDescription(String description, {bool needPaint = false}) {
  return Container(
    foregroundDecoration: needPaint
        ? BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1],
                colors: [Colors.white10, Colors.white]))
        : BoxDecoration(),
    child: Html(
      data: '''
                        $description
                        ''',
      onImageTap: (string) {
        print(string);
      },
      onLinkTap: (s) {
        print(s);
      },
    ),
  );
}

Widget buildDateTime(DateTime pubDate) {
  var diff = DateTime.now().difference(pubDate);
  var text = '';

  if (diff < Duration(hours: 1)) {
    text = '${diff.inMinutes} min ago';
  } else if (diff.inDays < 2) {
    var dd = DateFormat('hh:mm a').format(pubDate);
    text = 'at $dd';
  } else {
    text = DateFormat('d MMM, hh:mm a').format(pubDate);
  }
  return Text(
    '$text',
    style: TextStyle(color: Colors.white),
  );
}

Container buildBottom(
    RssItem item, int index, int length, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    color: Colors.black54,
    height: 40,
    padding: EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildDateTime(item.pubDate),
        Text(
          '${index + 1} of $length',
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
  );
}

buildBlurredBg(RssItem item) {
  return Container(
    height: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(item.enclosure.url),
        fit: BoxFit.cover,
      ),
    ),
    child: BackdropFilter(
      child: Container(
        color: Colors.black26,
      ),
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
    ),
  );
}
