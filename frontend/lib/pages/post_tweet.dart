import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';

import '../widgets/rounded_btn.dart';
import '../widgets/replyTweet.dart';

import '../pages/home.dart';

class PostTweet extends StatefulWidget {
  String? retweetSlug;
  PostTweet({Key? key, this.retweetSlug}) : super(key: key);

  @override
  State<PostTweet> createState() => _PostTweetState();
}

class _PostTweetState extends State<PostTweet> {
  PickedFile? _image;
  late SharedPreferences pref;
  String token = '';
  String curUser = '';
  Map profileData = {};
  TextEditingController bodyController = TextEditingController();
  Map retweetData = {};

  @override
  void initState() {
    if (widget.retweetSlug != null) {
      ApiControllers.instance.getSingleTweet(widget.retweetSlug).then((result) {
        setState(() {
          retweetData = result;
          print(retweetData);
        });
      });
    }
    ApiControllers.instance.getProfile('').then((value) {
      setState(
        () {
          profileData = value;
        },
      );
    });
    super.initState();
  }

  validateTweet() {
    if (bodyController.text.length > 500) {
      return false;
    } else if (bodyController.text.isEmpty && _image == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.retweetSlug == null)
          ? null
          : AppBar(
              backgroundColor: Colors.lightBlue,
            ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (widget.retweetSlug == null)
                  ? Container(
                      height:
                          GlobalControllers.instance.mediaHeight(context, .1),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'POST TWEET',
                        style: GoogleFonts.zenLoop(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                    )
                  : (retweetData.isEmpty)
                      ? Container()
                      : ReplyTweet(
                          tweetData: retweetData,
                        ),
              (widget.retweetSlug == null)
                  ? SizedBox(
                      height:
                          GlobalControllers.instance.mediaHeight(context, .05),
                    )
                  : Container(),
              SizedBox(
                width: GlobalControllers.instance.mediaWidth(context, 1),
                height: GlobalControllers.instance.mediaHeight(context, .07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius:
                          GlobalControllers.instance.mediaHeight(context, .035),
                      child: (profileData['image'] == null)
                          ? const Icon(
                              Icons.person,
                              size: 50,
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
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      height:
                          GlobalControllers.instance.mediaHeight(context, .07),
                      width:
                          GlobalControllers.instance.mediaWidth(context, .60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (profileData['nickname'] != null)
                              ? Text(
                                  profileData['nickname'],
                                  style: GoogleFonts.dosis(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                )
                              : Text(
                                  'Nickaname',
                                  style: GoogleFonts.dosis(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                          (profileData['username'] != null)
                              ? Text(
                                  '@' + profileData['username'],
                                  style: GoogleFonts.dosis(
                                      color: Colors.grey, fontSize: 20),
                                )
                              : Text(
                                  '@username',
                                  style: GoogleFonts.dosis(
                                      color: Colors.grey, fontSize: 20),
                                )
                        ],
                      ),
                    ),
                    RoundedBtnWidget(
                      height: null,
                      width: null,
                      func: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                title: const Text('Post tweet'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'CANCEL',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      validateTweet()
                                          ? ApiControllers.instance
                                              .postTweet(
                                              bodyController.text,
                                              _image,
                                              widget.retweetSlug,
                                            )
                                              .then(
                                              (result) {
                                                if (result) {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            const HomePage()),
                                                    (Route<dynamic> route) =>
                                                        false,
                                                  );
                                                } else {
                                                  Navigator.pop(context);
                                                  GlobalControllers.instance
                                                      .printErrorBar(context,
                                                          'Unable to post, somethings wrong!');
                                                }
                                              },
                                            )
                                          : GlobalControllers.instance
                                              .printErrorBar(context,
                                                  'Unable to post, somethings wrong!');
                                    },
                                    child: const Text(
                                      'POST',
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      label: 'Tweet',
                      color: Colors.lightBlue,
                    ),
                  ],
                ),
              ),
              (_image == null)
                  ? SizedBox(
                      height:
                          GlobalControllers.instance.mediaHeight(context, .02),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: GlobalControllers.instance
                              .mediaHeight(context, .02),
                        ),
                        Container(
                          height: GlobalControllers.instance
                              .mediaHeight(context, .2),
                          width:
                              GlobalControllers.instance.mediaWidth(context, 1),
                          color: Colors.grey[200],
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.redAccent,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: GlobalControllers.instance
                              .mediaHeight(context, .02),
                        ),
                      ],
                    ),
              SizedBox(
                width: GlobalControllers.instance.mediaWidth(context, 1),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    RoundedBtnWidget(
                        height: null,
                        width: null,
                        func: () async {
                          try {
                            var image = await ImagePicker.platform
                                .pickImage(source: ImageSource.camera);
                            setState(() {
                              _image = image!;
                            });
                          } on PlatformException catch (e) {
                            print('Failed to pick image: $e');
                          }
                        },
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
              SizedBox(
                height: GlobalControllers.instance.mediaHeight(context, .02),
              ),
              SizedBox(
                height: GlobalControllers.instance.mediaHeight(context, .3),
                width: GlobalControllers.instance.mediaWidth(context, .9),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      enabled: true,
                      controller: bodyController,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Whats on your mind?',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.lightBlue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Container(
                      width: GlobalControllers.instance.mediaWidth(context, .9),
                      alignment: Alignment.topRight,
                      child: Text(
                        bodyController.text.length.toString() + ' / 500',
                        style: (bodyController.text.length > 500)
                            ? const TextStyle(
                                color: Colors.redAccent,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
