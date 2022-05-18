import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './single_tweet.dart';

class TweetListPage extends StatefulWidget {
  final String token;
  const TweetListPage({Key? key, required this.token}) : super(key: key);

  @override
  State<TweetListPage> createState() => _TweetListPageState();
}

class _TweetListPageState extends State<TweetListPage> {
  Future _getList() async {
    // var jsonResponse = null;
    // var response = await http.get(
    //   Uri.parse("http://localhost:8000/api/tweet/list2/"),
    //   headers: {
    //     HttpHeaders.authorizationHeader: 'Token ' + widget.token,
    //   },
    // );

    // if (response.statusCode == 200) {
    //   jsonResponse = json.decode(response.body);
    //   return jsonResponse;
    // } else {
    //   return response.statusCode;
    // }
    try {
      var jsonResponse = null;
      var response = await http.get(
        Uri.parse("http://localhost:8000/api/tweet/list/"),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + widget.token,
        },
      );
      jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height - 56,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * .7,
            width: MediaQuery.of(context).size.width * .9,
            color: Colors.white,
            child: FutureBuilder(
              future: _getList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.toString() == 'null') {
                    return Text('Error Occured');
                  }
                  Map data = snapshot.data as Map;
                  return ListView.builder(
                    itemCount: data['results'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleTweetPage(
                                tweet: data['results']
                                    [data['results'].length - 1 - index],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(data['results']
                              [data['results'].length - 1 - index]['title']),
                          subtitle: Text(data['results']
                              [data['results'].length - 1 - index]['body']),
                        ),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
