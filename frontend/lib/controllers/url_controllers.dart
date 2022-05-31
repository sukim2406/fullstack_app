import 'package:get/get.dart';

class UrlControllers extends GetxController {
  static UrlControllers instance = Get.find();

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
    String profileUrl = baseUrl + '/api/profile/$target/detail/';

    return profileUrl;
  }

  postTweetUrl() {
    String postTweetUrl = baseUrl + '/api/tweet/create/';
    return postTweetUrl;
  }

  updateProfileUrl(curUser) {
    String updateProfileUrl = baseUrl + '/api/profile/$curUser/update/';

    return updateProfileUrl;
  }

  tweetListUrl() {
    String tweetListUrl = baseUrl + '/api/tweet/list/';
    return tweetListUrl;
  }

  userTweetUrl(author) {
    String userTweetUrl = baseUrl + '/api/tweet/$author/tweets/';
    return userTweetUrl;
  }

  likeTweetUrl() {
    String likeTweetUrl = baseUrl + '/api/like/create/';
    return likeTweetUrl;
  }

  likedByUserUrl(slug) {
    String likedByUserUrl = baseUrl + '/api/like/$slug/detail/';
    return likedByUserUrl;
  }

  unlikeTweetUrl(slug) {
    String unlikeTweetUrl = baseUrl + '/api/like/$slug/unlike/';
    return unlikeTweetUrl;
  }

  likedTweetListUrl(username) {
    String likedTweetListUrl = baseUrl + '/api/like/$username/list/';
    return likedTweetListUrl;
  }

  singleTweetUrl(slug) {
    String singleTweetUrl = baseUrl + '/api/tweet/$slug/detail/';
    return singleTweetUrl;
  }

  retweetUrl() {
    String retweetUrl = baseUrl + '/api/retweet/create/';
    return retweetUrl;
  }

  retweetByUserUrl(slug) {
    String retweetByUserUrl = baseUrl + '/api/retweet/$slug/detail/';
    return retweetByUserUrl;
  }

  undoRetweetUrl(slug) {
    String undoRetweetUrl = baseUrl + '/api/retweet/$slug/delete/';
    return undoRetweetUrl;
  }

  retweetListUrl(username) {
    String retweetListUrl = baseUrl + '/api/retweet/$username/list/';
    return retweetListUrl;
  }

  searchTweetUrl(keyword) {
    String searchTweetUrl = baseUrl + '/api/tweet/list?search=$keyword';
    return searchTweetUrl;
  }

  deleteTweetUrl(slug) {
    String deleteTweetUrl = baseUrl + '/api/tweet/$slug/delete/';
    return deleteTweetUrl;
  }

  deleteAccountUrl() {
    String deleteAccountUrl = baseUrl + '/api/account/delete/';
    return deleteAccountUrl;
  }
}
