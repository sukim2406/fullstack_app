import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';
import '../controllers/pref_controllers.dart';

import '../pages/account_update.dart';
import '../pages/password_update.dart';

import '../widgets/rounded_btn.dart';
import '../widgets/tweet.dart';

class AccountPage extends StatefulWidget {
  final VoidCallback updateCurUserLogout;
  const AccountPage({
    Key? key,
    required this.updateCurUserLogout,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late SharedPreferences pref;
  String token = '';
  String curUser = '';
  String curUserEmail = '';
  Map profileData = {};
  Map accountData = {};
  late TabController _tabController;
  String _nextPage = '';
  bool _initLoading = true;
  bool _addLoading = false;
  final List _tweets = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    PrefControllers.instance.getSharedPreferences().then(
      (value) {
        setState(
          () {
            pref = value;
          },
        );
        PrefControllers.instance.getToken(pref).then(
          (value) {
            setState(
              () {
                token = value;
              },
            );
          },
        );
      },
    );
    ApiControllers.instance.getProfile(curUser).then((value) {
      setState(() {
        profileData = value;
      });
    });
    ApiControllers.instance.getAccount().then(
      (value) {
        setState(
          () {
            accountData = value;
            print('accountData  = ' + accountData.toString());
            _initialLoad();
          },
        );
      },
    );
    _tabController = new TabController(length: 3, vsync: this);
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(_loadMore);
  //   super.dispose;
  // }

  logout() {
    ApiControllers.instance.logout().then((result) {
      if (result == null) {
        widget.updateCurUserLogout();
      }
    });
  }

  void _initialLoad() async {
    setState(() {
      _initLoading = true;
    });
    try {
      var data =
          await ApiControllers.instance.getUserTweets(accountData['username']);

      print('data = ' + data.toString());
      for (var tweet in data['results']) {
        var profileData =
            await ApiControllers.instance.getProfile(tweet['username']);
        tweet['nickname'] = profileData['nickname'];
        tweet['profileImage'] = profileData['image'];
        _tweets.add(tweet);
      }

      if (data['next'] != null) {
        setState(
          () {
            _nextPage = data['next'];
          },
        );
      }

      setState(() {
        _initLoading = false;
      });
    } catch (error) {
      GlobalControllers.instance
          .printErrorBar(context, 'Initial Load Error : ' + error.toString());
    }
  }

  void _loadMore() async {
    if (_nextPage.isNotEmpty &&
        !_initLoading &&
        !_addLoading &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _addLoading = true;
      });
      try {
        var data = await ApiControllers.instance.getTweetList(_nextPage);
        for (var tweet in data['results']) {
          var profileData =
              await ApiControllers.instance.getProfile(tweet['username']);
          tweet['nickname'] = profileData['nickname'];
          tweet['profileImage'] = profileData['image'];
          _tweets.add(tweet);
        }
        if (data['next'] != null) {
          setState(() {
            _nextPage = data['next'];
          });
        } else {
          _nextPage = '';
        }
        setState(() {
          _addLoading = false;
        });
      } catch (error) {
        GlobalControllers.instance
            .printErrorBar(context, 'loadMore = ' + error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(profileData.toString());
    print(accountData.toString());
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
                                        setState(() {
                                          profileData = value;
                                        });
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
                                color: Colors.redAccent,
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
                        text: 'Subscriptions',
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Center(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _tweets.length,
                            itemBuilder: (_, index) =>
                                Tweet(tweetData: _tweets[index]),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Screen 2',
                          ),
                        ),
                        Center(
                          child: Text(
                            'Screen 3',
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
