import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logbook_management/pages/Authentication/register.dart';
import 'package:logbook_management/pages/detailmhs.dart';
import 'package:logbook_management/pages/home.dart';
import 'package:logbook_management/pages/Authentication/login.dart';
import 'package:logbook_management/pages/Authentication/authentication.dart';
import 'package:logbook_management/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logbook_management/services/auth_services.dart';
import 'package:provider/provider.dart';

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
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthServices>.value(value: AuthServices()),
              StreamProvider<User>.value(
                  value: AuthServices().user, initialData: null)
            ],
            child: ScreenUtilInit(
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
            ),
          );
          // return
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Icon(Icons.error), Text("Something Went Wrong!")],
          ),
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Authentication();
      });
    case "/Home":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      });
    case "/Detailmhs":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Detailmhs();
      });
    case "/Register":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Register();
      });
    case "/Login":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Login();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Authentication();
      });
  }
}
