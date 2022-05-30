import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';
import '../controllers/pref_controllers.dart';

import '../pages/account_update.dart';
import '../pages/password_update.dart';
import '../pages/login.dart';

import '../widgets/rounded_btn.dart';
import '../widgets/tweet.dart';

class AccountPage extends StatefulWidget {
  VoidCallback? updateCurUserLogout;
  AccountPage({
    Key? key,
    this.updateCurUserLogout,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late SharedPreferences pref;
  String token = '';
  String curUser = '';
  Map profileData = {};
  Map accountData = {};
  late TabController _tabController;
  String _myTweetNextPage = '';
  bool _initMyTweetLoading = true;
  bool _addMyTweetLoading = false;
  final List _myTweets = [];
  late ScrollController _myTweetScrollController;
  String _likedTweetNextPage = '';
  bool _initLikedTweetLoading = true;
  bool _addLikedTweetLoading = false;
  final List _likedTweets = [];
  late ScrollController _likedTweetScrollController;
  String _retweetNextPage = '';
  bool _initRetweetLoading = true;
  bool _addRetweetLoading = false;
  final List _retweets = [];
  late ScrollController _retweetScrollController;

  @override
  void initState() {
    super.initState();
    PrefControllers.instance.getSharedPreferences().then(
      (value) {
        if (mounted) {
          setState(
            () {
              pref = value;
            },
          );
        }
        PrefControllers.instance.getToken(pref).then(
          (value) {
            if (mounted) {
              setState(
                () {
                  token = value;
                },
              );
            }
          },
        );
      },
    );
    ApiControllers.instance.getProfile(curUser).then((value) {
      if (mounted) {
        setState(() {
          profileData = value;
        });
      }
    });
    ApiControllers.instance.getAccount().then(
      (value) {
        if (mounted) {
          setState(
            () {
              accountData = value;
            },
          );
        }

        _initialMyTweetLoad();
        _initialLikedTweetLoad();
        _initialRetweetLoad();
      },
    );
    _tabController = new TabController(length: 3, vsync: this);
    _myTweetScrollController = ScrollController()
      ..addListener(_myTweetLoadMore);
    _likedTweetScrollController = ScrollController()
      ..addListener(_likedTweetLoadMore);
    _retweetScrollController = ScrollController()
      ..addListener(_retweetLoadMore);
  }

  logout() {
    ApiControllers.instance.logout().then((result) {
      if (result == null) {
        widget.updateCurUserLogout!();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  void _initialLikedTweetLoad() async {
    if (mounted) {
      setState(() {
        _initLikedTweetLoading = true;
      });
    }
    try {
      var data = await ApiControllers.instance.getLikedTweets('');
      for (var liked in data['results']) {
        var tweet =
            await ApiControllers.instance.getSingleTweet(liked['tweetSlug']);
        var profileData =
            await ApiControllers.instance.getProfile(tweet['username']);
        if (tweet['image'] != null) {
          tweet['image'] = GlobalControllers.instance.baseUrl + tweet['image'];
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

  void _initialRetweetLoad() async {
    if (mounted) {
      setState(() {
        _initRetweetLoading = true;
      });
    }
    try {
      var data = await ApiControllers.instance.getRetweets('');
      for (var liked in data['results']) {
        var tweet =
            await ApiControllers.instance.getSingleTweet(liked['tweetSlug']);
        var profileData =
            await ApiControllers.instance.getProfile(tweet['username']);
        if (tweet['image'] != null) {
          tweet['image'] = GlobalControllers.instance.baseUrl + tweet['image'];
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
          setState(
            () {
              _retweetNextPage = data['next'];
            },
          );
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

  void _retweetLoadMore() async {
    if (_retweetNextPage.isNotEmpty &&
        !_initRetweetLoading &&
        !_addRetweetLoading &&
        _retweetScrollController.position.extentAfter < 300) {
      if (mounted) {
        setState(() {
          _addRetweetLoading = true;
        });
      }
      try {
        var data = await ApiControllers.instance.getRetweets('');
        for (var liked in data['results']) {
          var tweet =
              await ApiControllers.instance.getSingleTweet(liked['tweetSlug']);
          var profileData =
              await ApiControllers.instance.getProfile(tweet['username']);
          if (tweet['image'] != null) {
            tweet['image'] =
                GlobalControllers.instance.baseUrl + tweet['image'];
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
        GlobalControllers.instance
            .printErrorBar(context, 'loadMore = ' + error.toString());
      }
    }
  }

  void _likedTweetLoadMore() async {
    if (_likedTweetNextPage.isNotEmpty &&
        !_initLikedTweetLoading &&
        !_addLikedTweetLoading &&
        _likedTweetScrollController.position.extentAfter < 300) {
      if (mounted) {
        setState(() {
          _addLikedTweetLoading = true;
        });
      }
      try {
        var data =
            await ApiControllers.instance.getTweetList(_likedTweetNextPage);
        for (var liked in data['results']) {
          var tweet =
              await ApiControllers.instance.getSingleTweet(liked['tweetSlug']);
          var profileData =
              await ApiControllers.instance.getProfile(tweet['username']);
          if (tweet['image'] != null) {
            tweet['image'] =
                GlobalControllers.instance.baseUrl + tweet['image'];
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
        GlobalControllers.instance
            .printErrorBar(context, 'loadMore = ' + error.toString());
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
      var data =
          await ApiControllers.instance.getUserTweets(accountData['username']);

      for (var tweet in data['results']) {
        var profileData =
            await ApiControllers.instance.getProfile(tweet['username']);
        tweet['nickname'] = profileData['nickname'];
        tweet['profileImage'] = profileData['image'];
        if (mounted) {
          setState(() {
            _myTweets.add(tweet);
          });
        }
      }

      if (data['next'] != null) {
        if (mounted) {
          setState(
            () {
              _myTweetNextPage = data['next'];
            },
          );
        }
      }
      if (mounted) {
        setState(() {
          _initMyTweetLoading = false;
        });
      }
    } catch (error) {
      GlobalControllers.instance
          .printErrorBar(context, 'Initial Load Error : ' + error.toString());
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
          var profileData =
              await ApiControllers.instance.getProfile(tweet['username']);
          tweet['nickname'] = profileData['nickname'];
          tweet['profileImage'] = profileData['image'];
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
        GlobalControllers.instance
            .printErrorBar(context, 'loadMore = ' + error.toString());
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _myTweetScrollController.removeListener(_myTweetLoadMore);
    _likedTweetScrollController.removeListener(_likedTweetLoadMore);
    _retweetScrollController.removeListener(_retweetLoadMore);
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
                      child: (profileData['image'] == null)
                          ? Icon(
                              Icons.person,
                              size: GlobalControllers.instance
                                  .mediaHeight(context, .18),
                              color: Colors.lightBlue,
                            )
                          : null,
                      backgroundImage: (profileData['image'] == null)
                          ? null
                          : NetworkImage(
                              GlobalControllers.instance.baseUrl +
                                  profileData['image'],
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: GlobalControllers.instance.mediaHeight(context, .15),
                  left: GlobalControllers.instance.mediaWidth(context, .7),
                  child: RoundedBtnWidget(
                    height: null,
                    width: null,
                    func: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Update Personal Info.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                    'All data will be erased',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'CANCEL',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ApiControllers.instance
                                            .deleteAccount()
                                            .then((result) {
                                          if (result) {
                                            widget.updateCurUserLogout!();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const LoginPage()),
                                              (Route<dynamic> route) => false,
                                            );
                                          } else {
                                            GlobalControllers.instance
                                                .printErrorBar(context,
                                                    'Account deletion error');
                                          }
                                        });
                                      },
                                      child: const Text(
                                        'DELETE',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text(
                              'DELETE ACCOUNT',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PasswordUpdatePage(
                                    accountData: accountData,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'CHANGE PASSWORD',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountUpdatePage(
                                    reload: () {
                                      ApiControllers.instance
                                          .getProfile(curUser)
                                          .then((value) {
                                        if (mounted) {
                                          setState(() {
                                            profileData = value;
                                          });
                                        }
                                      });
                                    },
                                    profileData: profileData,
                                  ),
                                ),
                              );
                            },
                            child: const Text('UPDATE INFO'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    label: 'UPDATE',
                    color: Colors.lightBlue,
                  ),
                ),
                Positioned(
                  top: GlobalControllers.instance.mediaHeight(context, .2),
                  left: GlobalControllers.instance.mediaWidth(context, .7),
                  child: RoundedBtnWidget(
                    height: null,
                    width: null,
                    func: logout,
                    label: 'LOG OUT',
                    color: Colors.red,
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
                  (profileData['nickname'] != null)
                      ? profileData['nickname']
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
                (profileData['username'] != null)
                    ? '@' + profileData['username']
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
                child: Text((profileData['message'] != null)
                    ? profileData['message']
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
