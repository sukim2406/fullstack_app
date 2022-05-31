import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../controllers/pref_controllers.dart';
import '../controllers/url_controllers.dart';

class ApiControllers extends GetxController {
  static ApiControllers instance = Get.find();

  login(email, password) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    Map data = {
      'username': email,
      'password': password,
    };

    var response = await http.post(
      Uri.parse(UrlControllers.instance.getLoginUrl()),
      body: data,
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        pref.setString(
          'token',
          jsonResponse['token'],
        );
        pref.setString(
          'curUser',
          jsonResponse['user'],
        );
        return 'success';
      } else {
        return 'jsonResponse null';
      }
    } else {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  register(email, username, password, password2) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    Map data = {
      'email': email,
      'username': username,
      'password': password,
      'password2': password2
    };

    var response = await http.post(
      Uri.parse(
        UrlControllers.instance.getRegisterUrl(),
      ),
      body: data,
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['response'] == 'successfully registered a new user') {
          pref.setString(
            'token',
            jsonResponse['token'],
          );
          pref.setString(
            'curUser',
            jsonResponse['username'],
          );
          return 'success';
        } else {
          return jsonResponse.toString();
        }
      } else {
        return 'jsonResponse null';
      }
    } else {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  getAccount() async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();

    String token = await PrefControllers.instance.getToken(pref);

    var response = await http.get(
      Uri.parse(
        UrlControllers.instance.getAccountUrl(),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      return null;
    }
  }

  updatePassword(data) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();

    String token = await PrefControllers.instance.getToken(pref);

    var response = await http.put(
      Uri.parse(
        UrlControllers.instance.getAccountUpdateUrl(),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
      body: data,
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['response'] == 'Account update success') {
          pref.remove('token');
          pref.remove('curUser');
          return null;
        } else {
          return jsonResponse.toString();
        }
      } else {
        return 'jsonResponse null';
      }
    } else {
      return response.body.toString();
    }
  }

  logout() async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();

    String token = await PrefControllers.instance.getToken(pref);

    var response = await http.post(
      Uri.parse(
        UrlControllers.instance.getLogoutUrl(),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    if (response.statusCode == 200) {
      pref.remove('token');
      pref.remove('curUser');
      return null;
    }
  }

  getProfile(String targetUser) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String curUser = await PrefControllers.instance.getCurUser(pref);

    var response = await http.get(
      Uri.parse(
        (targetUser.isNotEmpty)
            ? UrlControllers.instance.getProfileUrl(targetUser)
            : UrlControllers.instance.getProfileUrl(curUser),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      return null;
    }
  }

  updateProfile(nickname, message, image) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String curUser = await PrefControllers.instance.getCurUser(pref);

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(
        UrlControllers.instance.updateProfileUrl(curUser),
      ),
    );

    request.headers[HttpHeaders.authorizationHeader] = 'Token ' + token;

    if (nickname != null) {
      request.fields['nickname'] = nickname;
    }
    if (message != null) {
      request.fields['message'] = message;
    }

    if (image != null) {
      File file = File(image.path);
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          file.readAsBytesSync(),
          filename: image.path.split('/').last,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  postTweet(body, image, retweetSlug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        UrlControllers.instance.postTweetUrl(),
      ),
    );

    request.headers[HttpHeaders.authorizationHeader] = 'Token ' + token;

    if (body != null) {
      request.fields['body'] = body;
    }
    if (retweetSlug != null) {
      request.fields['retweetSlug'] = retweetSlug;
    }

    if (image != null) {
      File file = File(image.path);
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          file.readAsBytesSync(),
          filename: image.path.split('/').last,
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  getTweetList(String nextPage) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);

    var response = await http.get(
      nextPage.isNotEmpty
          ? Uri.parse(nextPage)
          : Uri.parse(
              UrlControllers.instance.tweetListUrl(),
            ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      return null;
    }
  }

  getUserTweets(author) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);

    var response = await http.get(
      Uri.parse(
        UrlControllers.instance.userTweetUrl(author),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      return null;
    }
  }

  likeTweet(userSlug, tweetSlug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);

    Map data = {
      'userSlug': userSlug,
      'tweetSlug': tweetSlug,
    };

    var response = await http.post(
      Uri.parse(
        UrlControllers.instance.likeTweetUrl(),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
      body: data,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  getLikedByUser(userSlug, tweetSlug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String slug = userSlug + '-' + tweetSlug;

    var response = await http.get(
      Uri.parse(
        UrlControllers.instance.likedByUserUrl(slug),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  unlikeTweet(userSlug, tweetSlug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String slug = userSlug + '-' + tweetSlug;

    var response = await http.delete(
      Uri.parse(
        UrlControllers.instance.unlikeTweetUrl(slug),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  getLikedTweets(String? user) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String curUser = await PrefControllers.instance.getCurUser(pref);

    var response = await http.get(
      Uri.parse(
        UrlControllers.instance.likedTweetListUrl(
          (user == '') ? curUser : user,
        ),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  getSingleTweet(slug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    var response = await http.get(
      Uri.parse(
        UrlControllers.instance.singleTweetUrl(slug),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      return null;
    }
  }

  retweet(userSlug, tweetSlug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);

    Map data = {
      'userSlug': userSlug,
      'tweetSlug': tweetSlug,
    };

    var response = await http.post(
      Uri.parse(
        UrlControllers.instance.retweetUrl(),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
      body: data,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  getRetweetByUser(userSlug, tweetSlug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String slug = userSlug + '-' + tweetSlug;

    var response = await http.get(
      Uri.parse(
        UrlControllers.instance.retweetByUserUrl(slug),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  undoRetweet(userSlug, tweetSlug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String slug = userSlug + '-' + tweetSlug;

    var response = await http.delete(
      Uri.parse(
        UrlControllers.instance.undoRetweetUrl(slug),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  getRetweets(String? user) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String curUser = await PrefControllers.instance.getCurUser(pref);

    var response = await http.get(
      Uri.parse(
        UrlControllers.instance.retweetListUrl(
          (user == '') ? curUser : user,
        ),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  searchTweets(String nextPage, String keyword) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);

    var response = await http.get(
      nextPage.isNotEmpty
          ? Uri.parse(nextPage)
          : Uri.parse(
              UrlControllers.instance.searchTweetUrl(keyword),
            ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    return json.decode(response.body);
  }

  deleteTweet(String slug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);

    var response = await http.delete(
      Uri.parse(
        UrlControllers.instance.deleteTweetUrl(slug),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  deleteAccount() async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);

    var response = await http.delete(
      Uri.parse(
        UrlControllers.instance.deleteAccountUrl(),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
