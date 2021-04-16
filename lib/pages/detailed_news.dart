import 'package:flutter/material.dart';
import 'package:gulf_news/components.dart';
import 'package:webfeed/domain/rss_item.dart';

class DetailedNews extends StatelessWidget {
  const DetailedNews({Key key, this.news}) : super(key: key);
  final RssItem news;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Source : GDN')));
              },
              icon: Icon(Icons.info))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(news.enclosure.url),
            buildTitle(news.title),
            buildTags(news.primaryCategory, news.label),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text('by : ${news.author}'),
            ),
            buildDescription(news.description),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
