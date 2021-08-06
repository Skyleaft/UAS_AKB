import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future register(String email, String password) async {
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

  Future login(String email, String password) async {
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

  Future loginWithGoogle() async {
    setLoading(true);
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential authResult =
          await firebaseAuth.signInWithCredential(credential);
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

  Future logout() async {
    await firebaseAuth.signOut();
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
