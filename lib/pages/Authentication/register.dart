import 'package:flutter/material.dart';
import 'package:logbook_management/Animation/FadeAnimation.dart';
import 'package:logbook_management/services/auth_services.dart';
import 'package:logbook_management/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  final Function toggleScreen;

  const Register({Key key, this.toggleScreen}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
  var statusLog = false;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
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
                  1.2,
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
                              await loginProvider.register(
                                  cusername.text.trim(), cpassword.text.trim());
                              if (loginProvider.errorMessage != null) {
                                _btnController2.error();
                                _showMyDialog(
                                    "Peringatan", loginProvider.errorMessage);
                              } else {
                                _btnController2.success();
                                nextScreen(context, "/Login");
                                Fluttertoast.showToast(
                                    msg: "Akun Berhasil Dibuat Silahkan Login",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 16.0);
                              }
                              _btnController2.reset();
                            },
                            borderRadius: 8,
                            child: Text('Register',
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
                              SizedBox(width: 5),
                              TextButton(
                                onPressed: () => widget.toggleScreen(),
                                child: Text(
                                  "Login",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (loginProvider.errorMessage != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Colors.amberAccent,
              child: ListTile(
                title: Text(loginProvider.errorMessage),
                leading: Icon(Icons.error),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => loginProvider.setMessage(null),
                ),
              ),
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
