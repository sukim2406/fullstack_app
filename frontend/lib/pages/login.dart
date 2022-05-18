import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/controllers/global_controllers.dart';
import 'package:frontend/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/logo.dart';
import '../widgets/text_input.dart';

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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // padding - top
              Expanded(
                child: Container(),
              ),
              // logo
              const LogoWidget(),
              SizedBox(
                height: GlobalControllers.instance.mediaHeight(
                  context,
                  .1,
                ),
              ),
              // Textfields
              TextInputWidget(
                height: GlobalControllers.instance.mediaHeight(context, .07),
                width: GlobalControllers.instance.mediaWidth(context, .8),
                controller: emailController,
                label: 'EMAIL',
                obsecure: false,
              ),
              TextInputWidget(
                height: GlobalControllers.instance.mediaHeight(context, .07),
                width: GlobalControllers.instance.mediaWidth(context, .8),
                controller: passwordController,
                label: 'PASSWORD',
                obsecure: true,
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
                        shared.setString("curUser", jsonResponse['user']);
                        print(jsonResponse.toString());
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
              // padding - bottom
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
