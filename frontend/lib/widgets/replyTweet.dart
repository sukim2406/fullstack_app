import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';

class ReplyTweet extends StatefulWidget {
  final Map tweetData;
  const ReplyTweet({
    Key? key,
    required this.tweetData,
  }) : super(key: key);

  @override
  State<ReplyTweet> createState() => _ReplyTweetState();
}

class _ReplyTweetState extends State<ReplyTweet> {
  Map data = {};
  @override
  void initState() {
    data = widget.tweetData;
    // TODO: implement initState
    ApiControllers.instance.getProfile(widget.tweetData['username']).then(
      (result) {
        setState(() {
          data['profileImage'] = result['image'];
          data['nickname'] = result['nickname'];
        });
      },
    );
    super.initState();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GlobalControllers.instance.mediaHeight(context, .2),
      width: GlobalControllers.instance.mediaWidth(context, 1),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: GlobalControllers.instance.mediaHeight(context, .01),
              ),
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: GlobalControllers.instance.mediaHeight(context, .035),
                child: (data['profileImage'] == null)
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.lightBlue,
                      )
                    : null,
                backgroundImage: (data['profileImage'] == null)
                    ? null
                    : NetworkImage(
                        GlobalControllers.instance.baseUrl +
                            data['profileImage'],
                      ),
              ),
              Expanded(
                child: VerticalDivider(
                  thickness: 3,
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            width: GlobalControllers.instance.mediaWidth(context, .77),
            // height: GlobalControllers.instance.mediaHeight(context, .2),
            child: Column(
              children: [
                SizedBox(
                  height: GlobalControllers.instance.mediaHeight(context, .01),
                ),
                Container(
                  height: GlobalControllers.instance.mediaHeight(context, .07),
                  width: GlobalControllers.instance.mediaWidth(context, .77),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (data['nickname'] != null)
                          ? Text(
                              data['nickname'],
                              style: GoogleFonts.dosis(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            )
                          : Text(
                              'Nickname',
                              style: GoogleFonts.dosis(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                      (data['username'] != null)
                          ? Text(
                              '@' + data['username'],
                              style: GoogleFonts.dosis(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            )
                          : Text(
                              '@Username',
                              style: GoogleFonts.dosis(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Row(children: [
                      Expanded(
                        child: Container(
                          child: Text(data['body']),
                        ),
                      ),
                      (data['image'] == null)
                          ? Container()
                          : Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              width: GlobalControllers.instance
                                  .mediaWidth(context, .28),
                              child: Image.network(
                                GlobalControllers.instance.baseUrl +
                                    data['image'],
                                fit: BoxFit.cover,
                              ),
                            )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyTweetListView extends StatefulWidget {
  final Map tweetData;
  const ReplyTweetListView({
    Key? key,
    required this.tweetData,
  }) : super(key: key);

  @override
  State<ReplyTweetListView> createState() => _ReplyTweetListViewState();
}

class _ReplyTweetListViewState extends State<ReplyTweetListView> {
  Map data = {};
  @override
  void initState() {
    data = widget.tweetData;
    // TODO: implement initState
    ApiControllers.instance.getProfile(widget.tweetData['username']).then(
      (result) {
        setState(() {
          data['profileImage'] = result['image'];
          data['nickname'] = result['nickname'];
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GlobalControllers.instance.mediaHeight(context, .1),
      width: GlobalControllers.instance.mediaWidth(context, 1),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                width: GlobalControllers.instance.mediaWidth(context, .15),
                child: CircleAvatar(
                  radius: GlobalControllers.instance.mediaHeight(context, .025),
                  child: (data['profileImage'] == null)
                      ? Icon(
                          Icons.person,
                          size: GlobalControllers.instance
                              .mediaHeight(context, .05),
                          color: Colors.lightBlue,
                        )
                      : null,
                  backgroundImage: (data['profileImage'] == null)
                      ? null
                      : NetworkImage(
                          GlobalControllers.instance.baseUrl +
                              data['profileImage'],
                        ),
                ),
              ),
              const Expanded(
                child: VerticalDivider(
                  thickness: 3,
                ),
              ),
            ],
          ),
          SizedBox(
            width: GlobalControllers.instance.mediaWidth(context, .85),
            child: Column(
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Text(
                        (data['nickname'] != null)
                            ? data['nickname']
                            : 'Nickname',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Text(
                        (data['username'] != null)
                            ? '@' + data['username']
                            : '@Username',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        (data['data_updated'] != null)
                            ? data['date_updated'].toString().substring(0, 10) +
                                ' ' +
                                data['date_updated']
                                    .toString()
                                    .substring(11, 16)
                            : '',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width:
                            GlobalControllers.instance.mediaWidth(context, .04),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: GlobalControllers.instance.mediaHeight(context, .01),
                ),
                SizedBox(
                  width: GlobalControllers.instance.mediaWidth(context, .9),
                  child: Text(widget.tweetData['body']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
