import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

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
                decoration: const InputDecoration(
                  hintText: 'EMAIL',
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .7,
              color: Colors.amber,
              child: TextField(
                controller: userController,
                decoration: const InputDecoration(
                  hintText: 'USER NAME',
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .7,
              color: Colors.amber,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'PASSWORD',
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .7,
              color: Colors.amber,
              child: TextField(
                controller: password2Controller,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'PASSWORD CONFIRM',
                ),
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
                    'email': emailController.text,
                    'username': userController.text,
                    'password': passwordController.text,
                    'password2': password2Controller.text,
                  };
                  var jsonResponse = null;
                  var response = await http.post(
                    Uri.parse("http://localhost:8000/api/account/register/"),
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
