import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class PrefControllers extends GetxController {
  static PrefControllers instance = Get.find();

  Future getSharedPreferences() async {
    var shared = await SharedPreferences.getInstance();

    return shared;
  }

  Future getToken(pref) async {
    var token = await pref.getString('token') ?? '';
    print('token = ' + token);
    return token;
  }

  Future getCurUser(pref) async {
    var curUser = await pref.getString('curUser') ?? '';
    print('curUser = ' + curUser);
    return curUser;
  }
}
