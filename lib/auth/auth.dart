import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:cspc_recog/main.dart';
import 'package:cspc_recog/providers/userData.dart';
import 'package:cspc_recog/settings.dart';
//import 'package:cspc_recog/auth/groupSelect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../urls.dart';
import 'package:cspc_recog/auth/models/TokenReceiver.dart';

import 'package:flutter/services.dart';
import 'package:cspc_recog/auth/register.dart';

import 'models/user.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  TokenReceiver myToken;
  User myUser;
  User afterUser;
  ProfileModel myProfile;
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
    //     .copyWith(statusBarColor: Colors.transparent));
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: colorMain),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerSection(),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFFBFBFB),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )),
                      child: Column(
                        children: [
                          Image(
                              filterQuality: FilterQuality.high,
                              image:
                                  AssetImage("assets/images/logo_letters.png")),
                          textSection(),
                          buttonSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  signIn(String id, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(UrlPrefix.urls + "users/auth/login/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": id,
        "password": pass,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data != null) {
        setState(() {
          _isLoading = false;
        });
        myToken = TokenReceiver.fromJson(data);

        userGet(myToken.token);

        /*
        print(myUser.userId);
        print(myUser.userName);
        */

        //logOut(myLogin.token);

        sharedPreferences.setString("token", myToken.token);
        //print(sharedPreferences.getString("token"));

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MyMainPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      print("login false");
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  userGet(String token) async {
    print("userget start");
    MyLoginUser myLogin = Provider.of<MyLoginUser>(context, listen: false);

    String knoxToken = 'Token ' + token;
    final response = await http.get(
      Uri.parse(UrlPrefix.urls + "users/auth/user/"),
      headers: <String, String>{
        'Authorization': knoxToken,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data != null) {
        myUser = User.fromJson(data);

        myLogin.setUser(myUser);

        getMyProfile(myUser.userId);

        /*
        afterUser = myLogin.getUser();
        print(afterUser.userName);
        print(afterUser.userId);
        print("end");
        */

        /*
        setState(() {
          _isLoading = false;
        });*/

      }
    } else {
      /*
      setState(() {
        _isLoading = false;
      });*/
    }
  }

  getMyProfile(int id) async {
    print("proflielist start");
    MyLoginUser myLogin = Provider.of<MyLoginUser>(context, listen: false);

    final response = await http.post(
      Uri.parse(UrlPrefix.urls + "users/auth/user/profile/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "user_id": id,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      print(data);
      final Map<String, dynamic> dataCast = data['profile'] ?? null;
      if (dataCast != null) {
        myProfile = ProfileModel.fromJson(dataCast);
        print(myProfile);
        myLogin.setProfile(myProfile);
      }
    } else {}
  }

  /*
    토큰 넣어주면 해당 토큰 사라짐

   */
  logOut(String token) async {
    String knoxToken = 'Token ' + token;

    final response = await http.post(
      Uri.parse(UrlPrefix.urls + "users/auth/logout/"),
      headers: <String, String>{
        'Authorization': knoxToken,
      },
    );

    print("logout");
    print(response.statusCode);

    if (response.statusCode == 204) {
      print("logout!");
    } else {
      print("logout false");
    }
  }

  Widget buttonSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.15),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                "회원가입",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage()));
              },
            ),
          ],
        ),
        ElevatedButton(
          child: Text(
            "로그인",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: colorMain,
            onPrimary: Colors.black,
            minimumSize: Size(MediaQuery.of(context).size.width, 40),
          ),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            signIn(idController.text, passwordController.text);
          },
        ),
      ]),
    );
  }

  final TextEditingController idController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Widget textSection() {
    return Column(
      children: <Widget>[
        Card(
          child: TextFormField(
            controller: idController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.black45),
            decoration: InputDecoration(
              hintText: "아이디",
              contentPadding: EdgeInsets.only(left: 13),
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.black45),
              constraints: BoxConstraints(maxWidth: width * 0.7),
            ),
          ),
        ),
        SizedBox(height: 30.0),
        Card(
          child: TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.black45),
            decoration: InputDecoration(
              hintText: "비밀번호",
              contentPadding: EdgeInsets.only(left: 13),
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.black45),
              constraints: BoxConstraints(maxWidth: width * 0.7),
            ),
          ),
        ),
      ],
    );
  }

  Container headerSection() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: height * 0.05),
      child: Image(
        image: AssetImage('assets/images/logo_character.png'),
      ),
    );
  }
}
