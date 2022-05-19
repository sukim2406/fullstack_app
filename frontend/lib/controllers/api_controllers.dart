import 'dart:convert';
import 'package:frontend/controllers/global_controllers.dart';
import 'package:frontend/controllers/pref_controllers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
        pref.setString('token', jsonResponse['token']);
        pref.setString('curUser', jsonResponse['user']);
        return null;
      } else {
        return 'jsonRespone null';
      }
    } else {
      return response.body.toString();
    }
  }
}
