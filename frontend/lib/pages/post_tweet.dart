import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../controllers/global_controllers.dart';

import '../widgets/rounded_btn.dart';
import '../widgets/text_input.dart';

class PostTweet extends StatefulWidget {
  const PostTweet({Key? key}) : super(key: key);

  @override
  State<PostTweet> createState() => _PostTweetState();
}

class _PostTweetState extends State<PostTweet> {
  PickedFile? _image;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: GlobalControllers.instance.mediaHeight(context, .1),
              width: GlobalControllers.instance.mediaWidth(context, 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  RoundedBtnWidget(
                    height: null,
                    width: null,
                    func: () {
                      print('post');
                    },
                    label: 'Tweet',
                    color: Colors.lightBlue,
                  ),
                  SizedBox(
                    width: GlobalControllers.instance.mediaWidth(context, .05),
                  ),
                ],
              ),
            ),
            Container(
              width: GlobalControllers.instance.mediaWidth(context, 1),
              height: GlobalControllers.instance.mediaHeight(context, .07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: GlobalControllers.instance.mediaWidth(context, .05),
                  ),
                  CircleAvatar(),
                  Expanded(
                    child: Container(),
                  ),
                  TextInputWidget(
                    height:
                        GlobalControllers.instance.mediaHeight(context, .07),
                    width: GlobalControllers.instance.mediaWidth(context, .75),
                    controller: titleController,
                    label: 'Something on your mind?',
                    obsecure: false,
                    enabled: true,
                  ),
                  SizedBox(
                    width: GlobalControllers.instance.mediaWidth(context, .05),
                  ),
                ],
              ),
            ),
            (_image == null)
                ? Container()
                : Container(
                    height: GlobalControllers.instance.mediaHeight(context, .2),
                    width: GlobalControllers.instance.mediaWidth(context, .8),
                    color: Colors.grey,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
            Container(
              height: GlobalControllers.instance.mediaHeight(context, .1),
              width: GlobalControllers.instance.mediaWidth(context, 1),
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  RoundedBtnWidget(
                      height: null,
                      width: null,
                      func: () {},
                      label: 'Take picture',
                      color: Colors.lightBlue),
                  Expanded(
                    child: Container(),
                  ),
                  RoundedBtnWidget(
                      height: null,
                      width: null,
                      func: () async {
                        try {
                          var image = await ImagePicker.platform
                              .pickImage(source: ImageSource.gallery);
                          setState(() {
                            _image = image!;
                          });
                        } on PlatformException catch (e) {
                          print('Failed to pick image: $e');
                        }
                      },
                      label: 'From gallery',
                      color: Colors.lightBlue),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * .05,
            // ),
            // Container(
            //   height: MediaQuery.of(context).size.height * .1,
            //   width: MediaQuery.of(context).size.width * .7,
            //   color: Colors.pink,
            //   child: TextField(
            //     controller: bodyController,
            //     decoration: const InputDecoration(
            //       hintText: 'TWEET',
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * .05,
            // ),
            // Container(
            //   height: MediaQuery.of(context).size.height * .1,
            //   width: MediaQuery.of(context).size.width * .7,
            //   color: Colors.green,
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * .05,
            // ),
            // Container(
            //   height: MediaQuery.of(context).size.height * .1,
            //   width: MediaQuery.of(context).size.width * .7,
            //   color: Colors.yellow,
            //   child: ElevatedButton(
            //     child: const Text('POST'),
            //     onPressed: () async {
            //       SharedPreferences shared =
            //           await SharedPreferences.getInstance();
            //       String token = (shared.getString('token') ?? '');
            //       Map data = {
            //         'title': titleController.text,
            //         'body': bodyController.text,
            //       };
            //       var jsonResponse = null;
            //       var response = await http.post(
            //         Uri.parse("http://localhost:8000/api/tweet/create/"),
            //         headers: {
            //           HttpHeaders.authorizationHeader: 'Token ' + token
            //         },
            //         body: data,
            //       );
            //       print(response.body);
            //       print(data);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
