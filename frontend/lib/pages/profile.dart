import 'package:flutter/material.dart';
import 'package:frontend/controllers/api_controllers.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';

import '../widgets/tweet.dart';

class ProfilePage extends StatefulWidget {
  final Map tweetData;
  const ProfilePage({
    Key? key,
    required this.tweetData,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _initMyTweetLoading = true;
  List _myTweets = [];
  String _myTweetNextPage = '';
  bool _addMyTweetLoading = false;
  late ScrollController _myTweetScrollController;

  void _initialMyTweetLoad() async {
    if (mounted) {
      setState(() {
        _initMyTweetLoading = true;
      });
    }
    try {
      var data = await ApiControllers.instance
          .getUserTweets(widget.tweetData['username']);
      for (var tweet in data['results']) {
        tweet['nickname'] = widget.tweetData['nickname'];
        tweet['profileImage'] = widget.tweetData['profileImage'];
        if (mounted) {
          setState(() {
            _myTweets.add(tweet);
          });
        }
      }
      if (data['next'] != null) {
        if (mounted) {
          setState(() {
            _myTweetNextPage = data['next'];
          });
        }
      }
      if (mounted) {
        setState(() {
          _initMyTweetLoading = false;
        });
      }
    } catch (error) {
      GlobalControllers.instance.printErrorBar(
          context, 'Initial my tweet load error : ' + error.toString());
    }
  }

  void _myTweetLoadMore() async {
    if (_myTweetNextPage.isNotEmpty &&
        !_initMyTweetLoading &&
        !_addMyTweetLoading &&
        _myTweetScrollController.position.extentAfter < 300) {
      if (mounted) {
        setState(() {
          _addMyTweetLoading = true;
        });
      }
    }
    try {
      var data = await ApiControllers.instance.getTweetList(_myTweetNextPage);
      for (var tweet in data['results']) {
        tweet['nickname'] = widget.tweetData['nickname'];
        tweet['profileImage'] = widget.tweetData['profileImage'];
        if (mounted) {
          setState(() {
            _myTweets.add(tweet);
          });
        }
      }
      if (data['next'] != null) {
        if (mounted) {
          setState(() {
            _myTweetNextPage = data['next'];
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _myTweetNextPage = '';
          });
        }
      }
      if (mounted) {
        setState(() {
          _addMyTweetLoading = false;
        });
      }
    } catch (error) {
      GlobalControllers.instance.printErrorBar(
          context, 'My tweet load more error : ' + error.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialMyTweetLoad();
    _tabController = TabController(length: 3, vsync: this);
    _myTweetScrollController = ScrollController()
      ..addListener(_myTweetLoadMore);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _myTweetScrollController.removeListener(_myTweetLoadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: GlobalControllers.instance.mediaHeight(context, .94),
        width: GlobalControllers.instance.mediaWidth(context, 1),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: GlobalControllers.instance.mediaHeight(context, .25),
                  width: GlobalControllers.instance.mediaWidth(context, 1),
                ),
                Container(
                  height: GlobalControllers.instance.mediaHeight(context, .15),
                  color: Colors.lightBlue[300],
                ),
                Positioned(
                  width: GlobalControllers.instance.mediaWidth(context, .5),
                  top: GlobalControllers.instance.mediaHeight(context, .05),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[50],
                    radius: GlobalControllers.instance.mediaHeight(context, .1),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius:
                          GlobalControllers.instance.mediaHeight(context, .09),
                      child: (widget.tweetData['profileImage'] == null)
                          ? Icon(
                              Icons.person,
                              size: GlobalControllers.instance
                                  .mediaHeight(context, .18),
                              color: Colors.lightBlue,
                            )
                          : null,
                      backgroundImage:
                          (widget.tweetData['profileImage'] == null)
                              ? null
                              : NetworkImage(
                                  GlobalControllers.instance.baseUrl +
                                      widget.tweetData['profileImage'],
                                ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: GlobalControllers.instance.mediaWidth(context, .80),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  (widget.tweetData['nickname'] != null)
                      ? widget.tweetData['nickname']
                      : 'null',
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: GlobalControllers.instance.mediaWidth(context, .80),
              child: Text(
                (widget.tweetData['username'] != null)
                    ? '@' + widget.tweetData['username']
                    : '@username',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: GlobalControllers.instance.mediaHeight(context, .025),
            ),
            Container(
              width: GlobalControllers.instance.mediaWidth(context, .85),
              height: GlobalControllers.instance.mediaHeight(context, .1),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.lightBlue,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text((widget.tweetData['message'] != null)
                    ? widget.tweetData['message']
                    : ''),
              ),
            ),
            SizedBox(
              height: GlobalControllers.instance.mediaHeight(context, .025),
            ),
            Container(
              width: GlobalControllers.instance.mediaWidth(context, 1),
              height: GlobalControllers.instance.mediaHeight(context, .43),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.lightBlue[300],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(
                        text: 'Tweets',
                      ),
                      Tab(
                        text: 'Likes',
                      ),
                      Tab(
                        text: 'Retweets',
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // SingleChildScrollView(
                        //   child: Center(
                        //     child: Text(_myTweets.toString()),
                        //   ),
                        // ),
                        Center(
                          child: ListView.builder(
                            controller: _myTweetScrollController,
                            itemCount: _myTweets.length,
                            itemBuilder: (_, index) =>
                                // ListTile(
                                //   title: Text(index.toString()),
                                // ),
                                Tweet(
                              tweetData: _myTweets[index],
                            ),
                          ),
                        ),
                        Center(
                          child: Text('Likes'),
                        ),
                        Center(
                          child: Text('Retweets'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: GlobalControllers.instance.mediaHeight(context, .1),
          color: Colors.lightBlue[300],
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 30,
          ),
        ),
      ),
    );
  }
}
