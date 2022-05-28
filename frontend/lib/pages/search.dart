import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';

import '../widgets/text_input.dart';
import '../widgets/rounded_btn.dart';
import '../widgets/tweet.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _nextPage = '';
  bool _initLoading = false;
  bool _addLoading = false;
  final List _tweets = [];
  late ScrollController _scrollController;

  void _initialLoad(keyword) async {
    if (mounted) {
      setState(() {
        _initLoading = true;
      });
    }
    try {
      var data = await ApiControllers.instance.searchTweets('', keyword);
      for (var tweet in data['results']) {
        var profileData =
            await ApiControllers.instance.getProfile(tweet['username']);
        tweet['nickname'] = profileData['nickname'];
        tweet['profileImage'] = profileData['image'];
        if (mounted) {
          setState(() {
            _tweets.add(tweet);
          });
        }
      }
      if (data['next'] != null) {
        if (mounted) {
          setState(() {
            _nextPage = data['next'];
          });
        }
      }
      if (mounted) {
        setState(() {
          _initLoading = false;
        });
      }
    } catch (error) {
      GlobalControllers.instance
          .printErrorBar(context, 'Search tweet error ' + error.toString());
    }
  }

  void _loadMore() async {
    if (_nextPage.isNotEmpty &&
        !_initLoading &&
        !_addLoading &&
        _scrollController.position.extentAfter < 300) {
      if (mounted) {
        setState(() {
          _addLoading = true;
        });
      }
      try {
        var data = await ApiControllers.instance.getTweetList(_nextPage);
        for (var tweet in data['results']) {
          var profileData =
              await ApiControllers.instance.getProfile(tweet['username']);
          tweet['nickname'] = profileData['nickname'];
          tweet['profileImage'] = profileData['image'];
          if (mounted) {
            setState(() {
              _tweets.add(tweet);
            });
          }
        }
        if (data['next'] != null) {
          if (mounted) {
            setState(
              () {
                _nextPage = data['next'];
              },
            );
          }
        } else {
          if (mounted) {
            setState(() {
              _nextPage = '';
            });
          }
        }
        if (mounted) {
          setState(() {
            _addLoading = false;
          });
        }
      } catch (error) {
        GlobalControllers.instance
            .printErrorBar(context, 'search loadmore error' + error.toString());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: GlobalControllers.instance.mediaHeight(context, .94),
        width: GlobalControllers.instance.mediaWidth(context, 1),
        child: Column(
          children: [
            Container(
              height: GlobalControllers.instance.mediaHeight(context, .1),
              alignment: Alignment.bottomCenter,
              child: Text(
                'SEARCH TWEET',
                style: GoogleFonts.zenLoop(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInputWidget(
                  height: GlobalControllers.instance.mediaHeight(context, .07),
                  width: GlobalControllers.instance.mediaWidth(context, .7),
                  controller: _searchController,
                  label: 'Search by context or username',
                  obsecure: false,
                  enabled: true,
                ),
                RoundedBtnWidget(
                  height: null,
                  width: null,
                  func: () {
                    if (mounted) {
                      setState(() {
                        _tweets.clear();
                      });
                    }
                    _initialLoad(_searchController.text);
                  },
                  label: 'Search',
                  color: Colors.lightBlue,
                )
              ],
            ),
            _initLoading
                ? const CircularProgressIndicator()
                : Container(
                    height:
                        GlobalControllers.instance.mediaHeight(context, .70),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _tweets.length,
                            itemBuilder: (_, index) =>
                                Tweet(tweetData: _tweets[index]),
                          ),
                        ),
                        (_addLoading)
                            ? const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
