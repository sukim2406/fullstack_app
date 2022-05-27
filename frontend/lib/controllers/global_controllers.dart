import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalControllers extends GetxController {
  static GlobalControllers instance = Get.find();

  //  url related
  String baseUrl = 'http://localhost:8000';

  getLoginUrl() {
    String loginUrl = baseUrl + '/api/account/login/';

    return loginUrl;
  }

  getRegisterUrl() {
    String registerUrl = baseUrl + '/api/account/register/';

    return registerUrl;
  }

  getLogoutUrl() {
    String loggoutUrl = baseUrl + '/api/account/logout/';

    return loggoutUrl;
  }

  getAccountUrl() {
    String accountUrl = baseUrl + '/api/account/detail/';

    return accountUrl;
  }

  getAccountUpdateUrl() {
    String accountUpdateUrl = baseUrl + '/api/account/update/';

    return accountUpdateUrl;
  }

  getProfileUrl(target) {
    String profileUrl = baseUrl + '/api/profile/${target}/detail/';

    return profileUrl;
  }

  postTweetUrl() {
    String postTweetUrl = baseUrl + '/api/tweet/create/';
    return postTweetUrl;
  }

  updateProfileUrl(curUser) {
    String updateProfileUrl = baseUrl + '/api/profile/${curUser}/update/';

    return updateProfileUrl;
  }

  tweetListUrl() {
    String tweetListUrl = baseUrl + '/api/tweet/list/';
    return tweetListUrl;
  }

  userTweetUrl(author) {
    String userTweetUrl = baseUrl + '/api/tweet/${author}/tweets/';
    return userTweetUrl;
  }

  likeTweetUrl() {
    String likeTweetUrl = baseUrl + '/api/like/create/';
    return likeTweetUrl;
  }

  likedByUserUrl(slug) {
    String likedByUserUrl = baseUrl + '/api/like/${slug}/detail/';
    return likedByUserUrl;
  }

  unlikeTweetUrl(slug) {
    String unlikeTweetUrl = baseUrl + '/api/like/${slug}/unlike/';
    return unlikeTweetUrl;
  }

  likedTweetListUrl(username) {
    String likedTweetListUrl = baseUrl + '/api/like/${username}/list/';
    return likedTweetListUrl;
  }

  singleTweetUrl(slug) {
    String singleTweetUrl = baseUrl + '/api/tweet/${slug}/detail/';
    return singleTweetUrl;
  }

  retweetUrl() {
    String retweetUrl = baseUrl + '/api/retweet/create/';
    return retweetUrl;
  }

  retweetByUserUrl(slug) {
    String retweetByUserUrl = baseUrl + '/api/retweet/${slug}/detail/';
    return retweetByUserUrl;
  }

  undoRetweetUrl(slug) {
    String undoRetweetUrl = baseUrl + '/api/retweet/${slug}/delete/';
    return undoRetweetUrl;
  }

  retweetListUrl(username) {
    String retweetListUrl = baseUrl + '/api/retweet/${username}/list/';
    return retweetListUrl;
  }

  // get / set size
  mediaHeight(context, multiple) {
    var height = MediaQuery.of(context).size.height * multiple;
    return height;
  }

  mediaWidth(context, multiple) {
    var width = MediaQuery.of(context).size.width * multiple;
    return width;
  }

  // snackbar
  printErrorBar(context, text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(text),
      ),
    );
  }

  // bottom navigation bar related
  TextStyle bottomNavBarTextStyles = GoogleFonts.zenLoop(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
  );
}
