import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_on_click/services/database.dart';
import 'package:travel_on_click/ui/helper/common_classes.dart';
import 'package:travel_on_click/ui/screens/authenticate/sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class _HomeState extends State<Home> {
  late String startingPoint;
  late String endingPoint;
  late String days;
  String? _email = "";
  String? _userId = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _email = prefs.getString("email");
      _userId = prefs.getString("userId");
      print("email $_email");
      print("email $_userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBarThemeCustom(AppBarActions().appBarActions(context)),
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      '$_email',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: Text(
                      'Here We plan the trips for you ',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Image(
                      height: 300.0,
                      width: 300.0,
                      image: AssetImage('lib/ui/assets/images/locate.png')),
                  Center(
                    child: Text(
                      'Welcome to TripTool App',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Choose Starting Point'),
                    onChanged: (value) {
                      setState(() {
                        startingPoint = value.trim();
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please Enter Starting Point";
                      }
                    },
                  ),
                  SizedBox(
                    height: 19.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Choose Destination',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: Icon(Icons.location_searching))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Destination';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        endingPoint = value.trim();
                      });
                    },
                  ),
                  SizedBox(
                    height: 19.0,
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Number of days for trip'),
                    validator: (value) {
                      try {
                        int.parse(value!);
                      } catch (e) {
                        return "please enter a number";
                      }
                      if (value.isEmpty) {
                        return 'Please enter No. of Days';
                      } else if (int.parse(value) > 5) {
                        return "Please enter a value <= 5";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        days = value.trim();
                      });
                    },
                  ),
                  SizedBox(height: 25.0),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          SnackBarWidget(
                                  duration: 3,
                                  text: "loading info.. please wait!!")
                              .showSnackBar(context);
                          DatabaseLocationService(uid: _userId!)
                              .updateUserData(startingPoint, endingPoint, days);

                          DatabaseLocationService(uid: _userId!)
                              .getUserData()
                              .then((value) => Navigator.pushNamed(
                                      context, '/load', arguments: {
                                    "startLoc": startingPoint,
                                    "endLoc": endingPoint,
                                    "noOfDays": days
                                  }));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: Text(
                        'Plan Here',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                  SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text('Confused on Trip? Leave us to choose the'),
                        TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn())),
                            child: Text('Destination'))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
