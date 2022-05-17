import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .7,
              color: Colors.amber,
              child: TextField(
                controller: emailController,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .7,
              color: Colors.pink,
              child: TextField(
                controller: passwordController,
                obscureText: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .7,
              color: Colors.green,
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences shared =
                      await SharedPreferences.getInstance();
                  Map data = {
                    'username': emailController.text,
                    'password': passwordController.text,
                  };
                  var jsonResponse = null;
                  var response = await http.post(
                    Uri.parse("http://localhost:8000/api/account/login/"),
                    body: data,
                  );
                  if (response.statusCode == 200) {
                    jsonResponse = json.decode(response.body);
                    if (jsonResponse != null) {
                      shared.setString("token", jsonResponse['token']);
                      print(jsonResponse.toString());
                      print(jsonResponse['token']);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage()),
                          (Route<dynamic> route) => false);
                    }
                  } else {
                    print(response.body);
                    print(data);
                  }
                },
                child: Text('LOGIN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
