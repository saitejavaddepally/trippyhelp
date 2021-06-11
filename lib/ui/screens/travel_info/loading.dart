import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'trip_weather.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String endingLocation = "";
  String startingLocation = "";
  int counter = 0;
  Map data = {};

  travelInfoWeatherLocation() async {
    // Starting Location
    TravelWeatherInfo weatherInfo = new TravelWeatherInfo(
      location: startingLocation,
      count: counter,
    );
    await weatherInfo.weatherInfo();
    // Ending location
    TravelWeatherInfo weatherInfo1 = new TravelWeatherInfo(
      location: endingLocation,
      count: counter,
    );
    await weatherInfo1.weatherInfo();

    // Pass the total information here
    Navigator.pushReplacementNamed(context, '/test', arguments: {
      // starting location information
      "startLocInfo": {
        "temperature": weatherInfo.temperature,
        "description": weatherInfo.description,
        "main": weatherInfo.main,
        "icon": weatherInfo.icon,
        "name": weatherInfo.city,
        "fiveDaysData" : weatherInfo.fiveDaysData,
        "count" : counter,
        "coord" : weatherInfo.coord,
        "mainData" : weatherInfo.mainData

      },

      // ending location information
      "endLocInfo": {
        "temperature1": weatherInfo1.temperature,
        "description1": weatherInfo1.description,
        "main1": weatherInfo1.main,
        "icon1": weatherInfo1.icon,
        "name1": weatherInfo1.city,
        "fiveDaysData1" : weatherInfo1.fiveDaysData,
        "coord1" : weatherInfo1.coord,
        "mainData1" : weatherInfo1.mainData

      }
    });
  }

  void getHomedata(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    int count = int.parse(data['noOfDays']);
    setState(() {
      endingLocation = data['endLoc'];
      startingLocation = data['startLoc'];
      counter = count;
    });

    travelInfoWeatherLocation();

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SpinKitCubeGrid(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
