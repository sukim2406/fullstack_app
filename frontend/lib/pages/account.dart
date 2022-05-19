import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';
import '../controllers/pref_controllers.dart';

import '../widgets/rounded_btn.dart';

class AccountPage extends StatefulWidget {
  final VoidCallback updateCurUserLogout;
  const AccountPage({
    Key? key,
    required this.updateCurUserLogout,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late SharedPreferences pref;
  String token = '';
  String curUser = '';
  Map profileData = {};

  @override
  void initState() {
    super.initState();
    PrefControllers.instance.getSharedPreferences().then(
      (value) {
        setState(
          () {
            pref = value;
          },
        );
        PrefControllers.instance.getToken(pref).then(
          (value) {
            setState(
              () {
                token = value;
              },
            );
          },
        );
      },
    );
    ApiControllers.instance.getProfile().then((value) {
      setState(() {
        profileData = value;
      });
    });
  }

  logout() {
    ApiControllers.instance.logout().then((result) {
      if (result == null) {
        widget.updateCurUserLogout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(profileData.toString());
    return Scaffold(
      body: Container(
        height: GlobalControllers.instance.mediaHeight(context, .94),
        width: GlobalControllers.instance.mediaWidth(context, 1),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: GlobalControllers.instance.mediaHeight(context, .25),
                  width: GlobalControllers.instance.mediaWidth(context, 1),
                ),
                Container(
                  height: GlobalControllers.instance.mediaHeight(context, .15),
                  color: Colors.lightBlue[300],
                ),
                Positioned(
                  width: GlobalControllers.instance.mediaWidth(context, .5),
                  top: GlobalControllers.instance.mediaHeight(context, .05),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[50],
                    radius: GlobalControllers.instance.mediaHeight(context, .1),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius:
                          GlobalControllers.instance.mediaHeight(context, .09),
                      child: (profileData['image'] == null)
                          ? Icon(
                              Icons.person,
                              size: GlobalControllers.instance
                                  .mediaHeight(context, .18),
                              color: Colors.lightBlue,
                            )
                          : null,
                      backgroundImage: (profileData['image'] == null)
                          ? null
                          : NetworkImage(
                              GlobalControllers.instance.baseUrl +
                                  profileData['image'],
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: GlobalControllers.instance.mediaHeight(context, .15),
                  left: GlobalControllers.instance.mediaWidth(context, .7),
                  child: RoundedBtnWidget(
                    height: null,
                    width: null,
                    func: () {},
                    label: 'UPDATE',
                    color: Colors.lightBlue,
                  ),
                ),
                Positioned(
                  top: GlobalControllers.instance.mediaHeight(context, .2),
                  left: GlobalControllers.instance.mediaWidth(context, .7),
                  child: RoundedBtnWidget(
                    height: null,
                    width: null,
                    func: logout,
                    label: 'LOG OUT',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: GlobalControllers.instance.mediaWidth(context, .80),
              child: Text(
                (profileData['nickname'] != null)
                    ? profileData['nickname']
                    : 'null',
                style: GoogleFonts.nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            SizedBox(
              width: GlobalControllers.instance.mediaWidth(context, .80),
              child: Text(
                (profileData['username'] != null)
                    ? profileData['username']
                    : 'null',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: GlobalControllers.instance.mediaHeight(context, .025),
            ),
            Container(
              width: GlobalControllers.instance.mediaWidth(context, .85),
              height: GlobalControllers.instance.mediaHeight(context, .1),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.lightBlue,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text((profileData['message'] != null)
                    ? profileData['message']
                    : ''),
              ),
            ),
            SizedBox(
              height: GlobalControllers.instance.mediaHeight(context, .025),
            ),
            Container(
              width: GlobalControllers.instance.mediaWidth(context, .85),
              height: GlobalControllers.instance.mediaHeight(context, .4),
              color: Colors.amber,
            ),
          ],
        ),
        // Center(
        //   child: RoundedBtnWidget(
        //     height: null,
        //     width: null,
        //     func: logout,
        //     label: 'LOG OUT',
        //     color: Colors.red,
        //   ),
        // ),
      ),
    );
  }
}
