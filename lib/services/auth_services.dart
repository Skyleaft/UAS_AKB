import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future Register(String email, String password) async {
    setLoading(true);
    try {
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No Internet, Please Connect to the Internet");
    } catch (e) {
      setLoading(false);
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future Login(String email, String password) async {
    setLoading(true);
    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = authResult.user;
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No Internet, Please Connect to the Internet");
    } catch (e) {
      setLoading(false);
      setMessage(e.message);
    }
    notifyListeners();
  }

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Stream<User> get user => firebaseAuth.authStateChanges().map((event) => null);
}
