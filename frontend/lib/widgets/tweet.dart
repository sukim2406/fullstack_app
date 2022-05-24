import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';

class Tweet extends StatefulWidget {
  final Map tweetData;
  const Tweet({
    Key? key,
    required this.tweetData,
  }) : super(key: key);

  @override
  State<Tweet> createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  bool _liked = false;
  bool _retweeted = false;

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
                  child: (widget.tweetData['profileImage'] == null)
                      ? Icon(
                          Icons.person,
                          size: GlobalControllers.instance
                              .mediaHeight(context, .05),
                          color: Colors.lightBlue,
                        )
                      : null,
                  backgroundImage: (widget.tweetData['profileImage'] == null)
                      ? null
                      : NetworkImage(
                          GlobalControllers.instance.baseUrl +
                              widget.tweetData['profileImage'],
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
                            widget.tweetData['nickname'],
                            style: GoogleFonts.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Container(),
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
                      child: Row(
                        children: [
                          Text(
                            '@' + widget.tweetData['username'],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            widget.tweetData['date_updated']
                                    .toString()
                                    .substring(0, 10) +
                                ' ' +
                                widget.tweetData['date_updated']
                                    .toString()
                                    .substring(11, 16),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: GlobalControllers.instance
                                .mediaWidth(context, .04),
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
                      child: Text(widget.tweetData['body']),
                    ),
                    SizedBox(
                      height:
                          GlobalControllers.instance.mediaHeight(context, .01),
                    ),
                    widget.tweetData['image'] != null
                        ? Column(
                            children: [
                              SizedBox(
                                height: GlobalControllers.instance
                                    .mediaHeight(context, .3),
                                width: GlobalControllers.instance
                                    .mediaWidth(context, .8),
                                child: Image.network(
                                  widget.tweetData['image'],
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
                          GestureDetector(
                            onTap: () {
                              ApiControllers.instance
                                  .likeTweet()
                                  .then((result) {
                                print(result);

                                setState(() {
                                  _liked = !_liked;
                                  print(widget.tweetData);
                                });
                              });
                            },
                            child: (_liked)
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.lightBlue,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                  ),
                            // Icon(
                            //   (_liked) ? Icons.favorite : Icons.favorite_border,
                            // ),
                          ),
                          Expanded(child: Container()),
                          const Icon(Icons.share),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _retweeted = !_retweeted;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          (_retweeted)
                                              ? 'Undo Retweet'
                                              : 'Retweet',
                                          style: const TextStyle(
                                            color: Colors.lightBlue,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: (_retweeted)
                                ? const Icon(
                                    Icons.autorenew,
                                    color: Colors.lightBlue,
                                  )
                                : const Icon(
                                    Icons.autorenew,
                                  ),
                          ),
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
