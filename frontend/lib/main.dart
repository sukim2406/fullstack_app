import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './pages/home.dart';
import './controllers/pref_controllers.dart';
import './controllers/global_controllers.dart';

void main() {
  Get.put(
    PrefControllers(),
  );
  Get.put(
    GlobalControllers(),
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
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
