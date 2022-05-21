import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/controllers/api_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/global_controllers.dart';

import '../widgets/text_input.dart';
import '../widgets/rounded_btn.dart';

class AccountUpdatePage extends StatefulWidget {
  final VoidCallback reload;
  final Map profileData;
  const AccountUpdatePage({
    Key? key,
    required this.profileData,
    required this.reload,
  }) : super(key: key);

  @override
  State<AccountUpdatePage> createState() => _AccountUpdatePageState();
}

class _AccountUpdatePageState extends State<AccountUpdatePage> {
  int _index = 0;
  PickedFile? _image;
  TextEditingController nicknameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  List<Step> getSteps() => [
        Step(
          state: (_index > 0) ? StepState.complete : StepState.indexed,
          isActive: _index >= 0,
          title: const Text('Nickname'),
          content: SizedBox(
            height: GlobalControllers.instance.mediaHeight(context, .3),
            width: GlobalControllers.instance.mediaWidth(context, .8),
            child: Column(
              children: [
                const Text('What should we call you ?'),
                SizedBox(
                  height: GlobalControllers.instance.mediaHeight(
                    context,
                    .05,
                  ),
                ),
                TextInputWidget(
                  enabled: true,
                  height: GlobalControllers.instance.mediaHeight(context, .07),
                  width: GlobalControllers.instance.mediaWidth(context, .7),
                  controller: nicknameController,
                  label: '',
                  obsecure: false,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: (_index > 1) ? StepState.complete : StepState.indexed,
          isActive: _index >= 1,
          title: const Text('Profile Picture'),
          content: SizedBox(
            height: GlobalControllers.instance.mediaHeight(context, .3),
            width: GlobalControllers.instance.mediaWidth(context, .8),
            child: Column(
              children: [
                Container(
                  height: GlobalControllers.instance.mediaHeight(context, .2),
                  width: GlobalControllers.instance.mediaWidth(context, .8),
                  color: Colors.grey[300],
                  child: Center(
                    child: _image != null
                        ? Image.file(File(_image!.path))
                        : widget.profileData['image'] != null
                            ? Image.network(GlobalControllers.instance.baseUrl +
                                widget.profileData['image'])
                            : Icon(
                                Icons.person,
                                size: GlobalControllers.instance
                                    .mediaHeight(context, .2),
                                color: Colors.lightBlue,
                              ),
                  ),
                ),
                SizedBox(
                  height: GlobalControllers.instance.mediaHeight(context, .02),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                      label: 'From Gallery',
                      color: Colors.black,
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
                      label: 'Take a Photo',
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Step(
          state: (_index > 2) ? StepState.complete : StepState.indexed,
          isActive: _index >= 2,
          title: const Text('Message'),
          content: SizedBox(
            height: GlobalControllers.instance.mediaHeight(context, .3),
            width: GlobalControllers.instance.mediaWidth(context, .8),
            child: Column(
              children: [
                const Text('Want to say something?'),
                SizedBox(
                  height: GlobalControllers.instance.mediaHeight(
                    context,
                    .05,
                  ),
                ),
                SizedBox(
                  height: GlobalControllers.instance.mediaHeight(context, .2),
                  width: GlobalControllers.instance.mediaWidth(context, .7),
                  child: TextField(
                    controller: messageController,
                    keyboardType: TextInputType.multiline,
                    minLines: null,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: '',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
            isActive: _index >= 3,
            title: const Text('Review'),
            content: SizedBox(
              height: GlobalControllers.instance.mediaHeight(context, .4),
              width: GlobalControllers.instance.mediaWidth(context, .8),
              child: Column(
                children: [
                  SizedBox(
                    width: GlobalControllers.instance.mediaHeight(context, .8),
                    child: const Text(
                      'Nickname: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    nicknameController.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height:
                        GlobalControllers.instance.mediaHeight(context, .01),
                  ),
                  SizedBox(
                    width: GlobalControllers.instance.mediaHeight(context, .8),
                    child: const Text(
                      'Profile Image: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height:
                        GlobalControllers.instance.mediaHeight(context, .15),
                    width: GlobalControllers.instance.mediaWidth(context, .8),
                    child: _image != null
                        ? Image.file(File(_image!.path))
                        : widget.profileData['image'] != null
                            ? Image.network(GlobalControllers.instance.baseUrl +
                                widget.profileData['image'])
                            : Icon(
                                Icons.person,
                                size: GlobalControllers.instance
                                    .mediaHeight(context, .2),
                                color: Colors.lightBlue,
                              ),
                  ),
                  SizedBox(
                    height:
                        GlobalControllers.instance.mediaHeight(context, .01),
                  ),
                  SizedBox(
                    width: GlobalControllers.instance.mediaHeight(context, .8),
                    child: const Text(
                      'Message: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: GlobalControllers.instance.mediaHeight(context, .1),
                    width: GlobalControllers.instance.mediaWidth(context, .7),
                    child: TextField(
                      enabled: false,
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: '',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nicknameController.text = widget.profileData['nickname'];
    messageController.text = widget.profileData['message'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Stepper(
        currentStep: _index,
        onStepCancel: () {
          if (_index > 0) {
            setState(() {
              _index -= 1;
            });
          }
        },
        onStepContinue: () {
          final isLastStep = (_index == getSteps().length - 1);
          if (isLastStep) {
            ApiControllers.instance
                .updateProfile(
                    nicknameController.text, messageController.text, _image)
                .then((result) {
              if (result) {
                widget.reload();
                Navigator.pop(context);
              } else {
                GlobalControllers.instance.printErrorBar(context,
                    'Update failed, most likely nickname already in use');
              }
            });
          } else {
            setState(() {
              _index += 1;
            });
          }
        },
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },
        steps: getSteps(),
      ),
    );
  }
}
