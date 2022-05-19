import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../pages/login.dart';

import './post_tweet.dart';
import './tweet_list.dart';
import './profile.dart';
import '../controllers/pref_controllers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences shared;
  String token = '';
  String curUser = '';
  @override
  void initState() {
    super.initState();
    PrefControllers.instance.getSharedPreferences().then(
      (value) {
        setState(() {
          shared = value;
        });
        PrefControllers.instance.getToken(shared).then(
          (value) {
            setState(() {
              token = value;
            });
          },
        );
        PrefControllers.instance.getCurUser(shared).then(
          (value) {
            setState(() {
              curUser = value;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: (token == '')
            ? const LoginPage()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      var response = await http.get(
                        Uri.parse(
                          "http://localhost:8000/api/profile/${curUser}/detail/",
                        ),
                        headers: {
                          HttpHeaders.authorizationHeader: 'Token ' + token
                        },
                      );
                      var jsonResponse = null;
                      if (response.statusCode == 200) {
                        jsonResponse = json.decode(response.body);
                        print(jsonResponse);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              profile: jsonResponse,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('PROFILE'),
                  ),
                  TextButton(
                    onPressed: () async {
                      var response = await http.post(
                        Uri.parse("http://localhost:8000/api/account/logout/"),
                        headers: {
                          HttpHeaders.authorizationHeader: 'Token ' + token
                        },
                      );
                      if (response.statusCode == 200) {
                        shared.remove('token');
                        shared.remove('curUser');
                      }
                      setState(() {
                        curUser = '';
                        token = '';
                      });
                    },
                    child: const Text(
                      'LOG OUT',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostTweet(),
                        ),
                      );
                    },
                    child: const Text(
                      'POST TWEET',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TweetListPage(
                            token: token,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'GET ALL TWEETS',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
