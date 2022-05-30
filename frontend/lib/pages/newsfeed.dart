import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';

import '../widgets/tweet.dart';

class NewsfeedPage extends StatefulWidget {
  VoidCallback? updateCurUserLogout;
  NewsfeedPage({
    Key? key,
    this.updateCurUserLogout,
  }) : super(key: key);

  @override
  State<NewsfeedPage> createState() => _NewsfeedPageState();
}

class _NewsfeedPageState extends State<NewsfeedPage> {
  String _nextPage = '';
  bool _initLoading = true;
  bool _addLoading = false;
  final List _tweets = [];
  late ScrollController _scrollController;

  updateCurUserLogout() {
    widget.updateCurUserLogout!();
  }

  void _reload() {
    if (mounted) {
      setState(() {
        _tweets.clear();
      });
    }
  }

  void _initialLoad() async {
    if (mounted) {
      setState(() {
        _initLoading = true;
      });
    }
    try {
      var data = await ApiControllers.instance.getTweetList('');
      for (var tweet in data['results']) {
        var profileData =
            await ApiControllers.instance.getProfile(tweet['username']);
        tweet['nickname'] = profileData['nickname'];
        tweet['profileImage'] = profileData['image'];
        tweet['message'] = profileData['message'];
        if (mounted) {
          setState(() {
            _tweets.add(tweet);
          });
        }
      }
      // _tweets = tweetData;
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
          .printErrorBar(context, 'Initial Load : ' + error.toString());
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
          tweet['message'] = profileData['message'];
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
            .printErrorBar(context, 'loadMore = ' + error.toString());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialLoad();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.removeListener(_loadMore);
    super.dispose();
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
                'NEWSFEED',
                style: GoogleFonts.zenLoop(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
            ),
            _initLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    height: GlobalControllers.instance.mediaHeight(context, .8),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _tweets.length,
                            itemBuilder: (_, index) => Tweet(
                              tweetData: _tweets[index],
                              updateCurUserLogout: widget.updateCurUserLogout,
                            ),
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
