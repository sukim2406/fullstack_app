import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/global_controllers.dart';
import '../controllers/api_controllers.dart';
import '../controllers/pref_controllers.dart';
import '../controllers/url_controllers.dart';

import '../pages/post_tweet.dart';
import '../pages/profile.dart';
import '../pages/account.dart';
import '../pages/home.dart';

import '../widgets/replyTweet.dart';

class Tweet extends StatefulWidget {
  VoidCallback? updateCurUserLogout;
  final Map tweetData;
  Tweet({
    Key? key,
    required this.tweetData,
    this.updateCurUserLogout,
  }) : super(key: key);

  @override
  State<Tweet> createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  bool _liked = false;
  bool _retweeted = false;
  String _curUser = '';
  Map _replyTweet = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PrefControllers.instance.getSharedPreferences().then(
      (value) {
        PrefControllers.instance.getCurUser(value).then(
          (curUser) {
            if (mounted) {
              setState(() {
                _curUser = curUser;
              });
            }
            ApiControllers.instance
                .getLikedByUser(_curUser, widget.tweetData['slug'])
                .then(
              (result) {
                if (mounted) {
                  setState(
                    () {
                      _liked = result;
                    },
                  );
                }
              },
            );
            ApiControllers.instance
                .getRetweetByUser(_curUser, widget.tweetData['slug'])
                .then((result) {
              if (mounted) {
                setState(() {
                  _retweeted = result;
                });
              }
            });
          },
        );
      },
    );
    if (widget.tweetData['retweetSlug'] != null) {
      ApiControllers.instance
          .getSingleTweet(widget.tweetData['retweetSlug'])
          .then(
        (result) {
          if (result != null) {
            if (mounted) {
              setState(
                () {
                  _replyTweet = result;
                },
              );
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GlobalControllers.instance.mediaWidth(context, 1),
      child: Column(
        children: [
          const Divider(
            color: Colors.lightBlue,
          ),
          (_replyTweet.isNotEmpty)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width:
                          GlobalControllers.instance.mediaWidth(context, .03),
                    ),
                    const Text(
                      'replying to',
                      style: TextStyle(
                        color: Colors.lightBlue,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    )
                  ],
                )
              : Container(),
          (_replyTweet.isNotEmpty)
              ? ReplyTweetListView(
                  tweetData: _replyTweet,
                )
              : Container(),
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
                          UrlControllers.instance.baseUrl +
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    tweetData: widget.tweetData,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              widget.tweetData['nickname'],
                              style: GoogleFonts.nunito(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          (_curUser == widget.tweetData['username'])
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Delete this tweet?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                ApiControllers.instance
                                                    .deleteTweet(widget
                                                        .tweetData['slug'])
                                                    .then((result) {
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
                                                    GlobalControllers.instance
                                                        .printErrorBar(context,
                                                            'Delete tweet unsuccessful');
                                                  }
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'DELETE',
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.delete_forever_outlined,
                                  ),
                                )
                              : Container(),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    tweetData: widget.tweetData,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              '@' + widget.tweetData['username'],
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(),
                            ),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostTweet(
                                    retweetSlug: widget.tweetData['slug'],
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.chat_bubble_outline),
                          ),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              _liked
                                  ? ApiControllers.instance
                                      .unlikeTweet(
                                      _curUser,
                                      widget.tweetData['slug'],
                                    )
                                      .then(
                                      (result) {
                                        if (result) {
                                          if (mounted) {
                                            setState(
                                              () {
                                                _liked = !_liked;
                                              },
                                            );
                                          }
                                        } else {
                                          GlobalControllers.instance.printErrorBar(
                                              context,
                                              'Unlike unsuccessful, something went wrong');
                                        }
                                      },
                                    )
                                  : ApiControllers.instance
                                      .likeTweet(
                                      _curUser,
                                      widget.tweetData['slug'],
                                    )
                                      .then(
                                      (result) {
                                        if (result) {
                                          if (mounted) {
                                            setState(
                                              () {
                                                _liked = !_liked;
                                              },
                                            );
                                          }
                                        } else {
                                          GlobalControllers.instance.printErrorBar(
                                              context,
                                              'Like unsuccessful, something went wrong');
                                        }
                                      },
                                    );
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
                                          (_retweeted)
                                              ? ApiControllers.instance
                                                  .undoRetweet(_curUser,
                                                      widget.tweetData['slug'])
                                                  .then((result) {
                                                  if (mounted) {
                                                    setState(() {
                                                      _retweeted = !_retweeted;
                                                    });
                                                  }
                                                })
                                              : ApiControllers.instance
                                                  .retweet(
                                                  _curUser,
                                                  widget.tweetData['slug'],
                                                )
                                                  .then(
                                                  (result) {
                                                    if (result) {
                                                      if (mounted) {
                                                        setState(
                                                          () {
                                                            _retweeted =
                                                                !_retweeted;
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      GlobalControllers.instance
                                                          .printErrorBar(
                                                              context,
                                                              'Unlike unsuccessful, something went wrong');
                                                    }
                                                  },
                                                );
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
