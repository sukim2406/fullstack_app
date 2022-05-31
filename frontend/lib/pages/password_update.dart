import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';

import '../pages/home.dart';

import '../widgets/text_input.dart';
import '../widgets/rounded_btn.dart';
import '../widgets/logo.dart';

class PasswordUpdatePage extends StatefulWidget {
  final Map accountData;
  const PasswordUpdatePage({
    Key? key,
    required this.accountData,
  }) : super(key: key);

  @override
  State<PasswordUpdatePage> createState() => _PasswordUpdatePageState();
}

class _PasswordUpdatePageState extends State<PasswordUpdatePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.accountData['email'];
    userController.text = widget.accountData['username'];
  }

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
              'PASSWORD UPDATE',
              style: GoogleFonts.dosis(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextInputWidget(
              enabled: false,
              height: GlobalControllers.instance.mediaHeight(context, .07),
              width: GlobalControllers.instance.mediaWidth(context, .8),
              controller: emailController,
              label: 'EMAIL',
              obsecure: false,
            ),
            TextInputWidget(
              enabled: false,
              height: GlobalControllers.instance.mediaHeight(context, .07),
              width: GlobalControllers.instance.mediaWidth(context, .8),
              controller: userController,
              label: 'USERNAME',
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
            TextInputWidget(
              enabled: true,
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
                if (passwordController.text.isEmpty ||
                    password2Controller.text.isEmpty) {
                  GlobalControllers.instance
                      .printErrorBar(context, 'Empty input field detected.');
                } else if (passwordController.text !=
                    password2Controller.text) {
                  GlobalControllers.instance
                      .printErrorBar(context, 'Password does not match.');
                } else {
                  var data = {
                    'email': emailController.text,
                    'username': userController.text,
                    'password': passwordController.text,
                    'password2': password2Controller.text,
                  };
                  ApiControllers.instance.updatePassword(data).then(
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
              label: 'UPDATE',
              color: Colors.blue,
            ),
            RoundedBtnWidget(
              height: null,
              width: null,
              func: () {
                Navigator.pop(context);
              },
              label: 'Cancel',
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
