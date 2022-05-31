import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalControllers extends GetxController {
  static GlobalControllers instance = Get.find();

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
