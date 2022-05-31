import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './pages/home.dart';
import './controllers/pref_controllers.dart';
import './controllers/global_controllers.dart';
import './controllers/api_controllers.dart';
import './controllers/url_controllers.dart';

void main() {
  Get.put(
    PrefControllers(),
  );
  Get.put(
    GlobalControllers(),
  );
  Get.put(
    ApiControllers(),
  );
  Get.put(
    UrlControllers(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        primarySwatch: Colors.blue,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black,
          selectionHandleColor: Colors.black,
        ),
      ),
      home: const HomePage(),
    );
  }
}
