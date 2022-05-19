import 'package:flutter/material.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';

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
  logout() {
    ApiControllers.instance.logout().then((result) {
      if (result == null) {
        widget.updateCurUserLogout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: GlobalControllers.instance.mediaHeight(context, .94),
        width: GlobalControllers.instance.mediaWidth(context, 1),
        color: Colors.amber,
        child: Center(
          child: RoundedBtnWidget(
            height: null,
            width: null,
            func: logout,
            label: 'LOG OUT',
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
