import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gulf_news/pages/gallery_article.dart';
import 'package:gulf_news/pages/standard_article.dart';
import 'package:gulf_news/services/rss_api.dart';
import 'package:webfeed/domain/rss_item.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

// https://gulfnews.com/rss/?generatorName=mrss&categories=Business,Banking,Aviation,Property,Energy,Analysis,Tourism,Markets,Retail,Personal-Finance,Podcast
class _HomeState extends State<Home> {
  ValueNotifier<List<RssItem>> valueitems = ValueNotifier<List<RssItem>>([]);
  List<RssItem> rssresult = [];
  var topicsrss = {
    'Top Stories': '0',
    'UAE':
        'UAE,Education,Crime,Government,Health,Weather,Transport,Science,Environment',
    // 'UAE': 'UAE',
    'Latest Business':
        'Business,Banking,Aviation,Property,Energy,Analysis,Tourism,Markets,Retail,Personal-Finance,Podcast',
    'Sport':
        'Sport,UAE-Sport,Horse-Racing,Cricket,IPL,ICC,Football,Motorsport,Tennis,Golf,Rugby',
    'Entertainment':
        'Entertainment,HollyWood,BollyWood,Pakistani-Cinema,Pinoy-Celebs,South-Indian,Arab-Celebs,Music,TV,Books,Theatre,Arts-Culture',
    'World':
        'World,Europe,Asia,India,Pakistan,Philipines,Oceania,Americas,Africa',
    'Travel': 'Travel,Advice,Destinations,Hotels',
    'Technology':
        'Technology,Consumer-Electronics,Gaming,Trends,Fin-Tech,Companies,Media'
  };
  var topicsDialog = [
    'Top Stories',
    'UAE',
    'Latest Business',
    'Sport',
    'Entertainment',
    'World',
    'Travel',
    'Technology'
  ];
  String msg = 'Trying to connect to the internet';
  PageController pageController;
  bool isBottomVisible = false;
  String currentTopic = '';
  bool isLoading = false;
  @override
  void initState() {
    currentTopic = 'Top Stories';
    pageController = PageController();
    valueitems.value = [];
    callApi(topicsrss[currentTopic]);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> callApi(String topic) async {
    setState(() {
      isLoading = true;
    });
    valueitems.value = [];
    rssresult = await getFeed(topic);
    if (rssresult != null) {
      loadResult();
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        msg = 'Can\'t connect to the internet';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AnimatedContainer(
            curve: Curves.easeInOut,
            height: isBottomVisible ? 50 : 0.0,
            child: BottomAppBar(
              child: GestureDetector(
                onTap: () {
                  var old = currentTopic;
                  showDialog(
                      context: context,
                      builder: (ctx) => SimpleDialog(
                          title: Text('Change Topic'),
                          children: List.generate(
                            topicsDialog.length,
                            (index) => RadioListTile<String>(
                                groupValue: currentTopic,
                                title: Text(topicsDialog[index]),
                                value: topicsDialog[index],
                                onChanged: (value) {
                                  currentTopic = value;
                                  Navigator.pop(context, value);
                                }),
                          ).toList())).then((value) {
                    setState(() {});
                    isBottomVisible = !isBottomVisible;
                    if (old != currentTopic) {
                      callApi(topicsrss[currentTopic]);
                    }
                  });
                },
                child: Container(
                  color: Colors.black12,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Tap to Change'),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        margin: EdgeInsets.only(left: 8),
                        color: Colors.green,
                        child: Text(
                          currentTopic,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            duration: Duration(
              milliseconds: 150,
            )),
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: valueitems,
            // future: getFeed(false),

            builder: (context, List<RssItem> snapshot, Widget child) {
              if (snapshot == null || snapshot.isEmpty) {
                return FutureBuilder(
                  future: Future.delayed(Duration(seconds: 15)),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isBottomVisible = !isBottomVisible;
                          });
                        },
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wysiwyg,
                                  size: 100,
                                ),
                                Text('Gulf News',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                CircularProgressIndicator()
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              padding: EdgeInsets.all(8),
                              child: LinearProgressIndicator(),
                            ),
                            Text(msg),
                            OutlinedButton(
                                onPressed: () {
                                  callApi(currentTopic);
                                },
                                child: Text('Refresh')),
                          ],
                        ),
                      );
                    }
                  },
                );
                // return Center(child: CircularProgressIndicator());
              } else {
                var list = snapshot;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isBottomVisible = !isBottomVisible;
                    });
                  },
                  child: PageView.builder(
                      controller: pageController,
                      itemCount: list.length,
                      scrollDirection: Axis.vertical,
                      onPageChanged: (i) {
                        if (i + 1 == valueitems.value.length) {
                          loadResult();
                          setState(() {});
                        }
                      },
                      itemBuilder: (ctx, index) {
                        if (list[index].articleType != 'galleryArticle') {
                          return Column(
                            children: [
                              if (isLoading) LinearProgressIndicator(),
                              Expanded(
                                child: buildStatnderArticle(
                                    list[index], index, list.length, context),
                              ),
                            ],
                          );
                        } else {
                          return buildGalleryArticle(list[index]);
                        }
                      }),
                );
              }
            },
          ),
        ));
  }

  void loadResult() {
    print('called');
    var start = valueitems.value.length;
    var end = start + 15;

    if (end > rssresult.length) {
      end = rssresult.length;
    }
    for (int i = start; i < end; i++) {
      valueitems.value.add(rssresult[i]);
    }
  }
}
