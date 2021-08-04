import 'package:flutter/material.dart';
import 'package:logbook_management/Animation/FadeAnimation.dart';
import 'package:logbook_management/utils/helper.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
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

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 2), () {
      chekUser(cusername, cpassword);
      if (statusLog) {
        controller.success();
        nextScreen(context, "/Home");
      } else {
        controller.error();
      }
      Timer(Duration(seconds: 2), () {
        _btnController2.reset();
      });
    });
  }

  final cusername = TextEditingController();
  final cpassword = TextEditingController();
  var statusLog = false;

  void chekUser(TextEditingController _user, _pass) async {
    if (_user.text == "" && _pass.text == "") {
      _showMyDialog("Peringatan", "Username/Password masih kosong");
      statusLog = false;
    } else if (_user.text != "admin" && _pass.text != "admin") {
      _showMyDialog("Peringatan", "username/password salah");
      statusLog = false;
    } else if (_user.text == "admin" && _pass.text == "admin") {
      statusLog = true;
      Fluttertoast.showToast(
          msg: "Selamat Datang Kembali, Admin",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    height: 700,
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
                  1,
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
                  1,
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
                child: Padding(
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
                                      bottom:
                                          BorderSide(color: Colors.grey[100]))),
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
                          onPressed: () => _doSomething(_btnController2),
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
                        MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            child: Align(
              alignment: Alignment(-1, 1),
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
