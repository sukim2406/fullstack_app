import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalControllers extends GetxController {
  static GlobalControllers instance = Get.find();

  String baseUrl = 'http://localhost:8000/';

  getLoginUrl() {
    String loginUrl = baseUrl + 'api/account/login/';

    return loginUrl;
  }

  mediaHeight(context, multiple) {
    var height = MediaQuery.of(context).size.height * multiple;
    return height;
  }

  mediaWidth(context, multiple) {
    var width = MediaQuery.of(context).size.width * multiple;
    return width;
  }

  printErrorBar(context, text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(text),
      ),
    );
  }
}
