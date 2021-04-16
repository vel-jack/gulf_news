import 'package:http/http.dart' as http;
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

Future<List<RssItem>> getFeed(String topic) async {
  var client = http.Client();
  var type = 'categories';
  if (topic == '0') {
    type = 'uuid';
    topic = '5bd9758c-9198-40ac-8d81-1e38745d5485';
  }
  // https://gulfnews.com/rss/?generatorName=mrss&uuid=5bd9758c-9198-40ac-8d81-1e38745d5485
  //
  // Uri uri = Uri.https('gulfnews.com', '/rss/', {
  //   'generatorName': 'mrss',
  //   'uuid': '5bd9758c-9198-40ac-8d81-1e38745d5485'
  // });

  // https://vel-jack.github.io/nothingbox/sampledata/gulfnews.com

// https://gulfnews.com/rss/?generatorName=mrss&categories=UAE,Education,Crime,Government,Health,Weather,Transport,Science,Environment
//
  // Uri uri =
  //     Uri.https('vel-jack.github.io', '/nothingbox/sampledata/gulfnews.com');

  Uri uri = Uri.https(
      'gulfnews.com', '/rss/', {'generatorName': 'mrss', type: '$topic'});
  try {
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var feed = RssFeed.parse(response.body
          .replaceAll('â', '\'')
          .replaceAll('â', '\'')
          .replaceAll('â', '-')
          .replaceAll('â', '"')
          .replaceAll('â', '"'));
      List<RssItem> latest = [];
      feed.items.forEach((element) {
        if (DateTime.now().difference(element.pubDate) < Duration(days: 3)) {
          // feed.items.remove(element);
          latest.add(element);
        }
      });
      return latest;
    }
  } catch (e) {
    print('Error $e');
  }
  return Future.value();
}
// get
