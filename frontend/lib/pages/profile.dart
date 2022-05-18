import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Map profile;
  const ProfilePage({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              CircleAvatar(
                backgroundImage: (profile['image'] != null)
                    ? NetworkImage(
                        'http://127.0.0.1:8000' + profile['image'],
                      )
                    : null,
                backgroundColor: Colors.red,
                radius: MediaQuery.of(context).size.width * .2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: Text(profile['nickname']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
