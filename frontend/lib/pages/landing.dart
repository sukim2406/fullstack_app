import 'package:flutter/material.dart';

import '../controllers/global_controllers.dart';

import '../pages/account.dart';
import '../pages/tweet_list.dart';
import '../pages/post_tweet.dart';

import '../widgets/bottom_navbar.dart';

class LandingPage extends StatefulWidget {
  final VoidCallback updateCurUserLanding;
  const LandingPage({
    Key? key,
    required this.updateCurUserLanding,
  }) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  updatePage(int newIndex) {
    setState(() {
      _curIndex = newIndex;
    });
  }

  updateCurUserLogout() {
    widget.updateCurUserLanding();
  }

  int _curIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomNavBarPages = [
      Text(
        'Newsfeed',
        style: GlobalControllers.instance.bottomNavBarTextStyles,
      ),
      PostTweet(),
      Text(
        'Topic',
        style: GlobalControllers.instance.bottomNavBarTextStyles,
      ),
      AccountPage(updateCurUserLogout: updateCurUserLogout)
    ];

    return Scaffold(
      body: Center(
        child: bottomNavBarPages[_curIndex],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        curIndex: _curIndex,
        updatePage: updatePage,
      ),
    );
  }
}
