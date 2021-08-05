import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logbook_management/pages/Authentication/register.dart';
import 'package:logbook_management/pages/detailmhs.dart';
import 'package:logbook_management/pages/home.dart';
import 'package:logbook_management/pages/Authentication/login.dart';
import 'package:logbook_management/pages/Authentication/authentication.dart';
import 'package:logbook_management/pages/wrapper.dart';
import 'package:logbook_management/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logbook_management/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyApp> {
  String token;
  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });
    getToken();
  }

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

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print(token);
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
        return Wrapper();
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
    case "/Authentication":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Authentication();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Wrapper();
      });
  }
}
