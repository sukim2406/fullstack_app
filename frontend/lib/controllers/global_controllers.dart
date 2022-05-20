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

  getProfileUrl(curUser) {
    String profileUrl = baseUrl + '/api/profile/${curUser}/detail/';

    return profileUrl;
  }

  updateProfileUrl(curUser) {
    String updateProfileUrl = baseUrl + '/api/profile/${curUser}/update/';

    return updateProfileUrl;
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
