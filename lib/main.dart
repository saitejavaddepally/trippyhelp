import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_on_click/services/authentication.dart';
import 'package:travel_on_click/ui/screens/authenticate/sign_in.dart';
import 'package:travel_on_click/ui/screens/home/home.dart';
import 'package:travel_on_click/ui/screens/home/comp_weat_info.dart';
import 'package:travel_on_click/ui/screens/travel_info/directions.dart';
import 'package:travel_on_click/ui/screens/travel_info/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'content_font'),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => Home(),
          '/test': (context) => Test(),
          '/load': (context) => Loading(),
          '/dir': (context) => Directions()
        },
        home: FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Home();
            } else {
              return SignIn();
            }
          },
        ));
  }
}
