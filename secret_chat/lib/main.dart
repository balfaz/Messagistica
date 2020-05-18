import 'package:flutter/material.dart';
import 'package:secret_chat/pages/home_page.dart';
import 'package:secret_chat/pages/splash_page.dart';
import 'package:secret_chat/provider/chat_provider.dart';
import 'pages/sign_up_page.dart';
import 'pages/login.dart';
import 'package:provider/provider.dart';
import 'provider/me.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Me(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        routes: {
          "splash": (context) => SplashPage(),
          "login": (context) => LoginPage(),
          "signup": (context) => SignUpPage(),
          "homepage": (context) => HomePage()
        },
      ),
    );
  }
}
