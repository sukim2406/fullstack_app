import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class PostTweet extends StatefulWidget {
  const PostTweet({Key? key}) : super(key: key);

  @override
  State<PostTweet> createState() => _PostTweetState();
}

class _PostTweetState extends State<PostTweet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

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
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'TITLE',
                ),
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
                controller: bodyController,
                decoration: const InputDecoration(
                  hintText: 'TWEET',
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
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .7,
              color: Colors.yellow,
              child: ElevatedButton(
                child: const Text('POST'),
                onPressed: () async {
                  SharedPreferences shared =
                      await SharedPreferences.getInstance();
                  String token = (shared.getString('token') ?? '');
                  Map data = {
                    'title': titleController.text,
                    'body': bodyController.text,
                  };
                  var jsonResponse = null;
                  var response = await http.post(
                    Uri.parse("http://localhost:8000/api/tweet/create/"),
                    headers: {
                      HttpHeaders.authorizationHeader: 'Token ' + token
                    },
                    body: data,
                  );
                  print(response.body);
                  print(data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
