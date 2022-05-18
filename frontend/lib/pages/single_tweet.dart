import 'package:flutter/material.dart';

class SingleTweetPage extends StatelessWidget {
  final Map tweet;
  const SingleTweetPage({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text(tweet.toString()),
      ),
    );
  }
}
