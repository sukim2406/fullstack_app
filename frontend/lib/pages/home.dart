import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../pages/login.dart';
import '../pages/landing.dart';

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
    updateCurUser() {
      setState(
        () {
          token = '';
          curUser = '';
        },
      );
    }

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: (token == '')
            ? const LoginPage()
            : LandingPage(
                updateCurUserLanding: updateCurUser,
              ),
      ),
    );
  }
}
