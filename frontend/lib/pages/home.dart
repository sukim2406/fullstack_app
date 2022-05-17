import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './login.dart';
import './signup.dart';
import './post_tweet.dart';
import './tweet_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences shared;
  String token = '';
  @override
  void initState() {
    super.initState();
    getSharedPreferences();
    getToken();
  }

  Future getSharedPreferences() async {
    shared = await SharedPreferences.getInstance();
  }

  Future getToken() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: (token == '')
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'LOG IN',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ));
                    },
                    child: const Text(
                      'SIGN UP',
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        getToken();
                      }
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
                      // var response = await http.get(
                      //   Uri.parse("http://localhost:8000/api/tweet/list/"),
                      //   headers: {
                      //     HttpHeaders.authorizationHeader: 'Token ' + token,
                      //   },
                      // );
                      // print(response.body);
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
