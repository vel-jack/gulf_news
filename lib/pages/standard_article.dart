import 'package:flutter/material.dart';
import 'package:gulf_news/components.dart';
import 'package:gulf_news/pages/detailed_news.dart';
import 'package:webfeed/domain/rss_item.dart';

Container buildStatnderArticle(
    RssItem item, int index, int length, BuildContext context) {
  return Container(
    color: Colors.white,
    child: Stack(
      children: [
        if (null != item.enclosure?.url) buildBlurredBg(item),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
                return DetailedNews(news: item);
              }));
            },
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (null != item.enclosure?.url)
                    Image.network(item.enclosure.url,
                        loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return CircularProgressIndicator();
                      }
                    })
                  else
                    Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 200,
                        color: Colors.black12,
                      ),
                    ),
                  buildTitle(item.title),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 50, child: buildTags(item.primaryCategory, item.label)),
        Positioned(bottom: 0, child: buildBottom(item, index, length, context))
      ],
    ),
  );
}
