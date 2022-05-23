import 'package:flutter/material.dart';

import '../controllers/global_controllers.dart';

class Tweet extends StatelessWidget {
  final Map tweetData;
  const Tweet({
    Key? key,
    required this.tweetData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GlobalControllers.instance.mediaWidth(context, 1),
      child: Column(
        children: [
          const Divider(
            color: Colors.lightBlue,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: GlobalControllers.instance.mediaWidth(context, .15),
                child: CircleAvatar(
                  radius: GlobalControllers.instance.mediaHeight(context, .025),
                  child: (tweetData['profileImage'] == null)
                      ? Icon(
                          Icons.person,
                          size: GlobalControllers.instance
                              .mediaHeight(context, .05),
                          color: Colors.lightBlue,
                        )
                      : null,
                  backgroundImage: (tweetData['profileImage'] == null)
                      ? null
                      : NetworkImage(
                          GlobalControllers.instance.baseUrl +
                              tweetData['profileImage'],
                        ),
                ),
              ),
              SizedBox(
                width: GlobalControllers.instance.mediaWidth(context, .85),
                child: Column(
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          Text(
                            tweetData['nickname'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text('@' + tweetData['username']),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            tweetData['date_updated']
                                    .toString()
                                    .substring(0, 10) +
                                ' ' +
                                tweetData['date_updated']
                                    .toString()
                                    .substring(11, 16),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: GlobalControllers.instance
                                .mediaWidth(context, .02),
                          ),
                          const Icon(Icons.more_vert),
                          SizedBox(
                            width: GlobalControllers.instance
                                .mediaWidth(context, .02),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height:
                          GlobalControllers.instance.mediaHeight(context, .01),
                    ),
                    SizedBox(
                      width: GlobalControllers.instance.mediaWidth(context, .9),
                      child: Text(tweetData['body']),
                    ),
                    SizedBox(
                      height:
                          GlobalControllers.instance.mediaHeight(context, .01),
                    ),
                    tweetData['image'] != null
                        ? Column(
                            children: [
                              SizedBox(
                                height: GlobalControllers.instance
                                    .mediaHeight(context, .3),
                                width: GlobalControllers.instance
                                    .mediaWidth(context, .8),
                                child: Image.network(
                                  tweetData['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: GlobalControllers.instance
                                    .mediaHeight(context, .01),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      width: GlobalControllers.instance.mediaWidth(context, .9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.chat_bubble_outline),
                          Expanded(child: Container()),
                          const Icon(Icons.favorite_border),
                          Expanded(child: Container()),
                          const Icon(Icons.share),
                          Expanded(child: Container()),
                          const Icon(Icons.autorenew),
                          Expanded(child: Container()),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.lightBlue,
          ),
        ],
      ),
    );
  }
}
