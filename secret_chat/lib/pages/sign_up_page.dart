import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secret_chat/api/auth_api.dart';
import 'package:secret_chat/functions/validazioni_campi.dart';
import 'package:secret_chat/widgets/circle.dart';
import 'package:secret_chat/widgets/input_text.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  var _username = '', _email = '', _password = '';
  var _isfetching = false;
  final _authAPI = AuthAPI();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  _submit() async {
    final isValid = _formKey.currentState.validate();

    if (_isfetching) return;

    if (isValid) {
      setState(() {
        _isfetching = true;
      });
      final isOk = await _authAPI.register(context,
          username: _username, email: _email, password: _password);

      setState(() {
        _isfetching = false;
      });
      if (isOk) {
        print("Register");
        Navigator.pushNamedAndRemoveUntil(context, 'splash', (_) => false);
      }
    }
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                right: -size.width * 0.15,
                top: -size.width * 0.34,
                child: Circle(
                  radius: size.width * 0.43,
                  colors: [Colors.purple[300], Colors.purple[100]],
                  alignmentEnd: Alignment.topCenter,
                  alignmentStart: Alignment.bottomCenter,
                ),
              ),
              Positioned(
                left: -size.width * 0.15,
                top: -size.width * 0.34,
                child: Circle(
                  radius: size.width * 0.35,
                  colors: [Colors.blue[300], Colors.blue[100]],
                  alignmentEnd: Alignment.topCenter,
                  alignmentStart: Alignment.bottomCenter,
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: size.width * 0.3),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26, blurRadius: 15),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 90.0,
                              width: 90.0,
                              //color: Colors.white,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "Hello again. \nWelcome back",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 350, minWidth: 350),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      InputButton(
                                        validator: (String text) {
                                          if (RegExp(r'^[a-zA-Z0-9]+$')
                                              .hasMatch(text)) {
                                            _username = text;
                                            return null;
                                          }
                                          return "invalid <Username>";
                                        },
                                        label: "Username",
                                        inputType: TextInputType.emailAddress,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      InputButton(
                                        validator: (String text) {
                                          _email = text;
                                          return (VerificaEmail(text));
                                        },
                                        label: "Email address",
                                        inputType: TextInputType.emailAddress,
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      InputButton(
                                          hiddenChar: true,
                                          label: "Password",
                                          validator: (String text) {
                                            _password = text;
                                            return VerificaPassword(text);
                                          }),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                    ],
                                  ),
                                )),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: 350, minWidth: 350),
                              child: CupertinoButton(
                                borderRadius: BorderRadius.circular(10.0),
                                padding: EdgeInsets.symmetric(vertical: 17),
                                color: Colors.purpleAccent,
                                onPressed: () => _submit(),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                                CupertinoButton(
                                    child: Text(
                                      "Sign In",
                                      style:
                                          TextStyle(color: Colors.purpleAccent),
                                    ),
                                    onPressed: () => Navigator.pop(context)),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.08,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 10.0,
                  left: 10.0,
                  child: SafeArea(
                    child: CupertinoButton(
                        padding: EdgeInsets.all(10),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black12,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context)),
                  )),
              _isfetching
                  ? Positioned.fill(
                      child: Container(
                      color: Colors.black45,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          radius: 15.0,
                        ),
                      ),
                    ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
