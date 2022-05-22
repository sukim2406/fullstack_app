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
    print('statuscode = ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['response'] == 'successfully registered a new user') {
          print('jsonResponse = ' + jsonResponse.toString());
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
          print('jsonResponse = ' + jsonResponse.toString());
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

  getProfile() async {
    SharedPreferences pref =
        await PrefControllers.instance.getSharedPreferences();
    String token = await PrefControllers.instance.getToken(pref);
    String curUser = await PrefControllers.instance.getCurUser(pref);

    var response = await http.get(
      Uri.parse(
        GlobalControllers.instance.getProfileUrl(curUser),
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

  postTweet(body, image) async {
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
    print('respone status code?' + response.statusCode.toString());
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
