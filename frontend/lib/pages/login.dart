import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/api_controllers.dart';
import '../controllers/global_controllers.dart';

import '../pages/home.dart';
import '../pages/signup.dart';

import '../widgets/logo.dart';
import '../widgets/text_input.dart';
import '../widgets/rounded_btn.dart';

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
          height: GlobalControllers.instance.mediaHeight(context, 1),
          width: GlobalControllers.instance.mediaWidth(context, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(),
              ),
              const LogoWidget(),
              SizedBox(
                height: GlobalControllers.instance.mediaHeight(
                  context,
                  .06,
                ),
              ),
              Text(
                'LOG IN',
                style: GoogleFonts.dosis(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextInputWidget(
                enabled: true,
                height: GlobalControllers.instance.mediaHeight(context, .07),
                width: GlobalControllers.instance.mediaWidth(context, .8),
                controller: emailController,
                label: 'EMAIL',
                obsecure: false,
              ),
              TextInputWidget(
                enabled: true,
                height: GlobalControllers.instance.mediaHeight(context, .07),
                width: GlobalControllers.instance.mediaWidth(context, .8),
                controller: passwordController,
                label: 'PASSWORD',
                obsecure: true,
              ),
              SizedBox(
                height: GlobalControllers.instance.mediaHeight(context, .05),
              ),
              RoundedBtnWidget(
                height: null,
                width: GlobalControllers.instance.mediaWidth(context, .5),
                func: () {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    GlobalControllers.instance
                        .printErrorBar(context, 'Empty input field detected.');
                  } else {
                    ApiControllers.instance
                        .login(emailController.text, passwordController.text)
                        .then(
                      (result) {
                        if (result == 'success') {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const HomePage()),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          GlobalControllers.instance.printErrorBar(
                              context, result['non_field_errors']);
                        }
                      },
                    );
                  }
                },
                label: 'LOG IN',
                color: Colors.blue,
              ),
              RoundedBtnWidget(
                height: null,
                width: null,
                func: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(),
                    ),
                  );
                },
                label: 'REGISTER',
                color: Colors.grey,
              ),
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
