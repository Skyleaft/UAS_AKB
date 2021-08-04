import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logbook_management/pages/detailmhs.dart';
import 'package:logbook_management/pages/home.dart';
import 'package:logbook_management/pages/login.dart';
import 'package:logbook_management/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logbook_management/services/auth_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _init = Firebase.initializeApp();
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget();
        } else if (snapshot.hasData) {
          return ScreenUtilInit(
            designSize: Size(375, 812),
            builder: () => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "LogBook Management",
              theme: ThemeData(
                scaffoldBackgroundColor: Constants.scaffoldBackgroundColor,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textTheme: GoogleFonts.poppinsTextTheme(),
              ),
              initialRoute: "/",
              onGenerateRoute: _onGenerateRoute,
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}

class ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [Icon(Icons.error), Text("Something Went Wrong!")],
    )));
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Login();
      });
    case "/Home":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      });
    case "/Detailmhs":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Detailmhs();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Login();
      });
  }
}
