import 'package:flutter/material.dart';
import 'package:travel_on_click/services/authentication.dart';
import 'package:travel_on_click/ui/screens/authenticate/sign_in.dart';

// Text Input Decoration

final textInputDecoration = InputDecoration(
  focusColor: Colors.grey,
  hintText: 'Enter UserName',
  border: InputBorder.none,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(10.0),
  ),
);

// Custom App Bar theme class
// ignore: must_be_immutable
class AppBarThemeCustom extends StatelessWidget with PreferredSizeWidget {
  List<Widget> actions;

  @override
  final Size preferredSize;
  AppBarThemeCustom(this.actions, {Key? key})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.fromLTRB(5.0, 20.0, 15.0, 15.0),
        child: Text(
          'TrippyHelp',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "app_font",
              letterSpacing: 2.0,
              fontSize: 20.0),
        ),
      ),
      actions: actions,
      centerTitle: true,
      titleSpacing: 6.0,
      backgroundColor: Colors.white,
      elevation: 0.0,
    );
  }
}

// Custom SnackBar Widget
class SnackBarWidget {
  String text;
  int duration;
  SnackBarWidget({required this.duration, required this.text});
  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        behavior: SnackBarBehavior.fixed,
        content: Text("$text"),
        duration: Duration(seconds: duration)));
  }
}

// Common Action Bar for loading and test

class AppBarActions {
  List<Widget> appBarActions(BuildContext context) {
    List<Widget> actions = [
      IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications,
            color: Colors.black,
          )),
      IconButton(
          onPressed: () {
            AuthMethods().signOut().then((value) {
              SnackBarWidget(duration: 2, text: "Signing out")
                  .showSnackBar(context);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            });
          },
          icon: Icon(
            Icons.logout,
            color: Colors.black,
          )),
    ];

    return actions;
  }
}

// WeatherCard
class WeatherCard {
  double temperature;
  String main;
  String description;
  String city;
  String icon;

  WeatherCard(
      {required this.temperature,
      required this.main,
      required this.description,
      required this.city,
      required this.icon});

  customCardForWeather() {
    int formattedValue = temperature.truncate();

    return Card(
      elevation: 50,
      shadowColor: Colors.black,
      color: Colors.grey[100],
      child: SizedBox(
        width: 450,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 58,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://openweathermap.org/img/w/$icon.png'), //NetworkImage
                    radius: 108,
                  ), //CircleAvatar
                ),
              ), //CirclAvatar
              SizedBox(
                height: 10,
              ), //SizedBox
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40.0, 0, 0),
                child: Column(
                  children: [
                    Text(
                      '$city'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green[900],
                        fontWeight: FontWeight.w500,
                      ), //Textstyle
                    ),
                    //Text
                    SizedBox(
                      height: 10,
                    ), //SizedBox
                    Text(
                      '$formattedValue\u2103',
                      style: TextStyle(
                        fontSize: 60,
                        color: Colors.green[900],
                      ), //Textstyle
                    ), //Text
                    Text(
                      main,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.green[900],
                      ), //Textstyle
                    ),
                    SizedBox(
                      height: 20,
                    ), //Size
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green[900],
                      ), //Textstyle
                    ),

                    SizedBox(
                      height: 10,
                    ), //SizedBox
                  ],
                ),
              ), //Column
            ],
          ),
        ), //Padding
      ), //SizedBox
    );
  }
}

class FiveDaysWeatherCard {
  String icon = '';
  double temperature = 0;
  FiveDaysWeatherCard({required this.icon, required this.temperature});

  fiveDaysWeatherCardPageView() {
    

    // return card(

    // )
  }
}


//  Google maps text field


  Widget googleMapsTextField({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? initialValue = '',
    double? width,
    Icon? prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return Container(
      width: width! * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        // initialValue: initialValue,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }