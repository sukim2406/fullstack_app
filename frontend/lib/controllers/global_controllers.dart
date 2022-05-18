import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalControllers extends GetxController {
  static GlobalControllers instance = Get.find();

  mediaHeight(context, multiple) {
    var height = MediaQuery.of(context).size.height * multiple;
    return height;
  }

  mediaWidth(context, multiple) {
    var width = MediaQuery.of(context).size.width * multiple;
    return width;
  }
}
