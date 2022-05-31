import 'package:flutter/material.dart';
import 'package:frontend/controllers/api_controllers.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/url_controllers.dart';

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
  final List _myTweets = [];
  String _myTweetNextPage = '';
  bool _addMyTweetLoading = false;
  late ScrollController _myTweetScrollController;

  bool _initLikedTweetLoading = true;
  final List _likedTweets = [];
  String _likedTweetNextPage = '';
  bool _addLikedTweetLoading = false;
  late ScrollController _likedTweetScrollController;

  bool _initRetweetLoading = true;
  final List _retweets = [];
  String _retweetNextPage = '';
  bool _addRetweetLoading = false;
  late ScrollController _retweetScrollController;

  void _initialRetweetLoad() async {
    if (mounted) {
      setState(
        () {
          _initRetweetLoading = true;
        },
      );
    }
    try {
      var data = await ApiControllers.instance
          .getRetweets(widget.tweetData['username']);
      for (var retweet in data['results']) {
        var tweet =
            await ApiControllers.instance.getSingleTweet(retweet['tweetSlug']);
        var profileData =
            await ApiControllers.instance.getProfile(tweet['username']);
        if (tweet['image'] != null) {
          tweet['image'] = UrlControllers.instance.baseUrl + tweet['image'];
        }
        tweet['nickname'] = profileData['nickname'];
        tweet['profileImage'] = profileData['image'];
        if (mounted) {
          setState(() {
            _retweets.add(tweet);
          });
        }
      }
      if (data['next'] != null) {
        if (mounted) {
          setState(() {
            _retweetNextPage = data['next'];
          });
        }
      }
      if (mounted) {
        setState(() {
          _initRetweetLoading = false;
        });
      }
    } catch (error) {
      GlobalControllers.instance.printErrorBar(
          context, 'Initial Retweet Load Error : ' + error.toString());
    }
  }

  void _reweetLoadMore() async {
    if (_retweetNextPage.isNotEmpty &&
        !_initRetweetLoading &&
        !_addRetweetLoading &&
        _retweetScrollController.position.extentAfter < 300) {
      if (mounted) {
        setState(
          () {
            _addRetweetLoading = true;
          },
        );
      }
      try {
        var data = await ApiControllers.instance.getTweetList(_retweetNextPage);
        for (var retweet in data['results']) {
          var tweet = await ApiControllers.instance
              .getSingleTweet(retweet['tweetSlug']);
          var profileData =
              await ApiControllers.instance.getProfile(tweet['username']);
          if (tweet['image'] != null) {
            tweet['image'] = UrlControllers.instance.baseUrl + tweet['image'];
          }
          tweet['nickname'] = profileData['nickname'];
          tweet['profileImage'] = profileData['image'];
          if (mounted) {
            setState(() {
              _retweets.add(tweet);
            });
          }
        }
        if (data['next'] != null) {
          if (mounted) {
            setState(() {
              _retweetNextPage = data['next'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _retweetNextPage = '';
            });
          }
        }
        if (mounted) {
          setState(() {
            _addRetweetLoading = false;
          });
        }
      } catch (error) {
        GlobalControllers.instance.printErrorBar(
            context, 'Retweet load more error : ' + error.toString());
      }
    }
  }

  void _initialLikedTweetLoad() async {
    if (mounted) {
      setState(() {
        _initLikedTweetLoading = true;
      });
    }
    try {
      var data = await ApiControllers.instance
          .getLikedTweets(widget.tweetData['username']);
      for (var liked in data['results']) {
        var tweet =
            await ApiControllers.instance.getSingleTweet(liked['tweetSlug']);
        var profileData =
            await ApiControllers.instance.getProfile(tweet['username']);
        if (tweet['image'] != null) {
          tweet['image'] = UrlControllers.instance.baseUrl + tweet['image'];
        }
        tweet['nickname'] = profileData['nickname'];
        tweet['profileImage'] = profileData['image'];
        if (mounted) {
          setState(() {
            _likedTweets.add(tweet);
          });
        }
      }
      if (data['next'] != null) {
        if (mounted) {
          setState(
            () {
              _likedTweetNextPage = data['next'];
            },
          );
        }
      }
      if (mounted) {
        setState(() {
          _initLikedTweetLoading = false;
        });
      }
    } catch (error) {
      GlobalControllers.instance.printErrorBar(
          context, 'Initial Liked Tweet Load Error : ' + error.toString());
    }
  }

  void _likedTweetLoadMore() async {
    if (_likedTweetNextPage.isNotEmpty &&
        !_initLikedTweetLoading &&
        !_addLikedTweetLoading &&
        _likedTweetScrollController.position.extentAfter < 300) {
      if (mounted) {
        setState(
          () {
            _addLikedTweetLoading = true;
          },
        );
      }
      try {
        var data =
            await ApiControllers.instance.getTweetList(_likedTweetNextPage);
        print('data = ' + data.toString());
        for (var liked in data['results']) {
          var tweet =
              await ApiControllers.instance.getSingleTweet(liked['tweetSlug']);
          var profileData =
              await ApiControllers.instance.getProfile(tweet['username']);
          if (tweet['image'] != null) {
            tweet['image'] = UrlControllers.instance.baseUrl + tweet['image'];
          }
          tweet['nickname'] = profileData['nickname'];
          tweet['profileImage'] = profileData['image'];
          ;
          if (mounted) {
            setState(() {
              _likedTweets.add(tweet);
            });
          }
        }
        if (data['next'] != null) {
          if (mounted) {
            setState(() {
              _likedTweetNextPage = data['next'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _likedTweetNextPage = '';
            });
          }
        }
        if (mounted) {
          setState(() {
            _addLikedTweetLoading = false;
          });
        }
      } catch (error) {
        GlobalControllers.instance.printErrorBar(
            context, 'Liked tweet load more error : ' + error.toString());
      }
    }
  }

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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialMyTweetLoad();
    _initialLikedTweetLoad();
    _initialRetweetLoad();
    _tabController = TabController(length: 3, vsync: this);
    _myTweetScrollController = ScrollController()
      ..addListener(_myTweetLoadMore);
    _likedTweetScrollController = ScrollController()
      ..addListener(_likedTweetLoadMore);
    _retweetScrollController = ScrollController()..addListener(_reweetLoadMore);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _myTweetScrollController.removeListener(_myTweetLoadMore);
    _myTweetScrollController.dispose();
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
                                  UrlControllers.instance.baseUrl +
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
                        Center(
                          child: ListView.builder(
                            controller: _myTweetScrollController,
                            itemCount: _myTweets.length,
                            itemBuilder: (_, index) => Tweet(
                              tweetData: _myTweets[index],
                            ),
                          ),
                        ),
                        Center(
                          child: ListView.builder(
                            controller: _likedTweetScrollController,
                            itemCount: _likedTweets.length,
                            itemBuilder: (_, index) => Tweet(
                              tweetData: _likedTweets[index],
                            ),
                          ),
                        ),
                        Center(
                          child: ListView.builder(
                            controller: _retweetScrollController,
                            itemCount: _retweets.length,
                            itemBuilder: (_, index) => Tweet(
                              tweetData: _retweets[index],
                            ),
                          ),
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
