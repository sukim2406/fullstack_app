import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';

import '../controllers/global_controllers.dart';
import '../controllers/pref_controllers.dart';

class ApiControllers extends GetxController {
  static ApiControllers instance = Get.find();

  login(email, password) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    Map data = {
      'username': email,
      'password': password,
    };

    var jsonResponse = null;
    var response = await http.post(
      Uri.parse(
        GlobalControllers.instance.getLoginUrl(),
      ),
      body: data,
    );
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        pref.setString(
          'token',
          jsonResponse['token'],
        );
        pref.setString(
          'curUser',
          jsonResponse['user'],
        );
        return null;
      } else {
        return 'jsonRespone null';
      }
    } else {
      return response.body.toString();
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

    var jsonResponse = null;
    var response = await http.post(
      Uri.parse(
        GlobalControllers.instance.getRegisterUrl(),
      ),
      body: data,
    );
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
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

  getAccount() async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();

    String token = await PrefControllers.instance.getToken(pref);

    var response = await http.get(
      Uri.parse(
        GlobalControllers.instance.getAccountUrl(),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
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
        GlobalControllers.instance.getAccountUpdateUrl(),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
      body: data,
    );
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['response'] == 'Account update success') {
          // pref.setString(
          //   'token',
          //   jsonResponse['token'],
          // );
          // pref.setString(
          //   'curUser',
          //   jsonResponse['username'],
          // );
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
        GlobalControllers.instance.getLogoutUrl(),
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
            ? GlobalControllers.instance.getProfileUrl(targetUser)
            : GlobalControllers.instance.getProfileUrl(curUser),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
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

    var request = await http.MultipartRequest(
      'PUT',
      Uri.parse(
        GlobalControllers.instance.updateProfileUrl(curUser),
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
    String curUser = await PrefControllers.instance.getCurUser(pref);

    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(
        GlobalControllers.instance.postTweetUrl(),
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
    String curUser = await PrefControllers.instance.getCurUser(pref);

    var response = await http.get(
      nextPage.isNotEmpty
          ? Uri.parse(nextPage)
          : Uri.parse(
              GlobalControllers.instance.tweetListUrl(),
            ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
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
        GlobalControllers.instance.userTweetUrl(author),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
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
        GlobalControllers.instance.likeTweetUrl(),
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
        GlobalControllers.instance.likedByUserUrl(slug),
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
        GlobalControllers.instance.unlikeTweetUrl(slug),
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

  getLikedTweets() async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String curUser = await PrefControllers.instance.getCurUser(pref);

    var response = await http.get(
      Uri.parse(
        GlobalControllers.instance.likedTweetListUrl(curUser),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      jsonResponse = json.decode(response.body);
      return jsonResponse;
    }
  }

  getSingleTweet(slug) async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    var response = await http.get(
      Uri.parse(
        GlobalControllers.instance.singleTweetUrl(slug),
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Token ' + token,
      },
    );
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      jsonResponse = json.decode(response.body);
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
        GlobalControllers.instance.retweetUrl(),
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
}
