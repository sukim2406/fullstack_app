import 'package:http/http.dart' as http;
import 'dart:io';

main() {
  createTweetTest();
}

registerTest() async {
  var response = await http.post(
      Uri.parse("http://localhost:8000/api/account/register/"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'email': 'test2@test.com',
        'username': 'testuser2',
        'password': 'password1234',
        'password2': 'password1234',
      });
  print(response.body);
}

loginTest() async {
  var response = await http.post(
      Uri.parse("http://localhost:8000/api/account/login/"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'username': 'test2@test.com',
        'password': 'password1234',
      });
  print(response.body);
}

deleteTweetTest() async {
  var response = await http.delete(
      Uri.parse("http://localhost:8000/api/tweet/testuser2-test2/delete/"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader:
            'Token 29d4a21c954b3a5ec33f92e110adaf15f33c1109',
      });
  print(response.body);
}

createTweetTest() async {
  var response = await http.post(
      Uri.parse("http://localhost:8000/api/tweet/create/"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader:
            'Token 29d4a21c954b3a5ec33f92e110adaf15f33c1109',
      },
      body: <String, String>{
        'title': 'this works?',
        'body': 'body body',
      });
  print(response.body);
}

// updateTweetTest() async {
//   var response = await http.put(

//   )
// }