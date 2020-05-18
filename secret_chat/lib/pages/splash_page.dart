import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:secret_chat/api/auth_api.dart';
import 'package:secret_chat/api/profile_api.dart';
import 'package:secret_chat/models/user_model.dart';
import 'package:secret_chat/provider/me.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authApi = AuthAPI();
  final _profile = profileAPI();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Me _me;

  @override
  void initState() {
    super.initState();
    this.check();
  }

  check() async {
    final token = await _authApi.getAccessToken();
    if (token != null) {
      final result = await _profile.getuserInfo(context, token);
      final user = User.fromJson(result);
      final FirebaseUser firebaseUser = (await _auth.signInAnonymously()).user;
      assert(firebaseUser != null);
      assert(firebaseUser.isAnonymous);
      print("firebase login OK");

      //print("user : ${user.username}");
      //print("email: ${user.email}");
      //print("user json ${user.toJson()}");

      _me.data = user;
      Navigator.pushReplacementNamed(context, "homepage");
    } else {
      Navigator.pushReplacementNamed(context, "login");
    }
  }

  @override
  Widget build(BuildContext context) {
    _me = Me.of(context);
    return Scaffold(
      body: Center(
          child: CupertinoActivityIndicator(
        radius: 15.0,
      )),
    );
  }
}
