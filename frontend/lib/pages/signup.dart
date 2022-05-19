import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';

import '../pages/home.dart';
import '../pages/login.dart';

import '../widgets/text_input.dart';
import '../widgets/rounded_btn.dart';
import '../widgets/logo.dart';

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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoWidget(),
            SizedBox(
              height: GlobalControllers.instance.mediaHeight(
                context,
                .06,
              ),
            ),
            Text(
              'REGISTER',
              style: GoogleFonts.dosis(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
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
              controller: userController,
              label: 'USERNAME',
              obsecure: false,
            ),
            TextInputWidget(
              height: GlobalControllers.instance.mediaHeight(context, .07),
              width: GlobalControllers.instance.mediaWidth(context, .8),
              controller: passwordController,
              label: 'PASSWORD',
              obsecure: true,
            ),
            TextInputWidget(
              height: GlobalControllers.instance.mediaHeight(context, .07),
              width: GlobalControllers.instance.mediaWidth(context, .8),
              controller: password2Controller,
              label: 'PASSWORD CONFRIM',
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
                    userController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    password2Controller.text.isEmpty) {
                  GlobalControllers.instance
                      .printErrorBar(context, 'Empty input field detected.');
                } else if (passwordController.text !=
                    password2Controller.text) {
                  GlobalControllers.instance
                      .printErrorBar(context, 'Password does not match');
                } else {
                  ApiControllers.instance
                      .register(
                    emailController.text,
                    userController.text,
                    passwordController.text,
                    password2Controller.text,
                  )
                      .then(
                    (result) {
                      if (result == null) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const HomePage()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        GlobalControllers.instance
                            .printErrorBar(context, result);
                      }
                    },
                  );
                }
              },
              label: 'REGISTER',
              color: Colors.blue,
            ),
            RoundedBtnWidget(
              height: null,
              width: null,
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              label: 'LOG IN',
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
