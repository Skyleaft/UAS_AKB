import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logbook_management/pages/Authentication/login.dart';
import 'package:logbook_management/pages/home.dart';
import 'package:provider/provider.dart';

import 'Authentication/authentication.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user != null) {
      return Home();
    } else {
      return Authentication();
    }
  }
}
