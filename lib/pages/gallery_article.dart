import 'package:flutter/material.dart';
import 'package:webfeed/domain/rss_item.dart';

Container buildGalleryArticle(RssItem gallery) {
  return Container(
    padding: EdgeInsets.all(10),
    // color: Colors.blue[50],
    child: Column(
      children: [
        Container(
            padding: EdgeInsets.all(8),
            child: Text('${gallery.title}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),
        Expanded(
          child: PageView.builder(
              itemCount: gallery.media.contents.length,
              itemBuilder: (ctx, i) {
                var media = gallery.media.contents[i];
                return Center(
                  child: Column(
                    children: [
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(8),
                                height: 300,
                                child: Center(child: Image.network(media.url))),
                            if (media.mediaTitle != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  getMediaTitle(media.mediaTitle),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ),
                            if (media.credit != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Image credit : ${media.credit}',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: i > 0 ? Colors.black : Colors.black26,
                          ),
                          Text(
                            'Swipe',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.keyboard_arrow_right,
                              color: i < gallery.media.contents.length - 1
                                  ? Colors.black
                                  : Colors.black26),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${i + 1}/${gallery.media.contents.length}')
                        ],
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    ),
  );
}

String getMediaTitle(String mediaTitle) {
  if (mediaTitle.length > 200) {
    return '${mediaTitle.substring(0, 150)}...';
  }
  return mediaTitle;
}
