import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logbook_management/Animation/FadeAnimation.dart';
import 'package:logbook_management/services/auth_services.dart';
import 'package:logbook_management/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

class Login extends StatefulWidget {
  final Function toggleScreen;

  const Login({Key key, this.toggleScreen}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

  Future<void> _showMyDialog(String _tittle, String _msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_tittle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final cusername = TextEditingController();
  final cpassword = TextEditingController();

  String checkDisplayName(var _user) {
    var finalDisplayName;
    if (_user.displayName == null) {
      finalDisplayName = _user.email;
    } else {
      finalDisplayName = _user.displayName;
    }
    return finalDisplayName;
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Stack(
            children: [
              Positioned(
                child: FadeAnimation(
                  1,
                  Container(
                    height: 650,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset('assets/images/Vector.png')),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: FadeAnimation(
                  1.3,
                  Container(
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/logo-lb.png')),
                  ),
                ),
              ),
              Positioned(
                top: 200,
                child: FadeAnimation(
                  1.8,
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset('assets/images/Vector2.png'),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 300,
                left: 35,
                right: 35,
                child: FadeAnimation(
                  1.5,
                  OutlinedButton(
                    onPressed: () async {
                      await loginProvider.loginWithGoogle();
                      if (loginProvider.errorMessage != null) {
                        _showMyDialog("Peringatan", loginProvider.errorMessage);
                      } else {
                        replaceScreen(context, "/Home");
                        Fluttertoast.showToast(
                            msg:
                                "Selamat Datang Kembali ${checkDisplayName(currentUser)}",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                      }
                    },
                    child: loginProvider.isLoading
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                    image: AssetImage(
                                        "assets/images/google_logo.png"),
                                    height: 28.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                top: 350,
                left: 0,
                right: 0,
                child: FadeAnimation(
                  1.5,
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 350,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[100]))),
                                child: TextField(
                                  controller: cusername,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.mail),
                                      hintText: "Email",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                              Container(
                                width: 350,
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: cpassword,
                                  autofocus: false,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.vpn_key),
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                          2,
                          RoundedLoadingButton(
                            color: Colors.indigo[600],
                            successColor: Colors.green[800],
                            controller: _btnController2,
                            onPressed: () async {
                              await loginProvider.login(
                                  cusername.text.trim(), cpassword.text.trim());
                              if (loginProvider.errorMessage != null) {
                                _btnController2.error();
                                _showMyDialog(
                                    "Peringatan", loginProvider.errorMessage);
                              } else {
                                _btnController2.success();
                                replaceScreen(context, "/Home");
                                Fluttertoast.showToast(
                                    msg:
                                        "Selamat Datang Kembali ${checkDisplayName(currentUser)}",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 16.0);
                              }
                              _btnController2.reset();
                            },
                            borderRadius: 8,
                            child: Text('Login',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                          1.5,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Belum Punya Akun? "),
                              SizedBox(width: 5),
                              TextButton(
                                onPressed: () => widget.toggleScreen(),
                                child: Text(
                                  "Register",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            child: Align(
              alignment: Alignment(0, 1),
              child: Container(
                height: 30,
                child: Image.asset('assets/images/logo-mz3.png'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
