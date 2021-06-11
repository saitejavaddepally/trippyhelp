import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class TravelWeatherInfo {
  double temperature = 0.0;
  String location = '';
  int count = 0;
  String main = '';
  String description = '';
  String icon = '';
  String city = '';
  final String apiKey = "6904157c82d4c4f60708fed182385700";
  List fiveDaysData = [];
  // List fiveDaysDataEnd = [];
  Map coord = {};
  List mainData = [];
  TravelWeatherInfo({required this.location, required this.count});

  Future<void> weatherInfo() async {
    Response weatherResult = await get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$location&cnt=40&units=metric&appid=6904157c82d4c4f60708fed182385700"));
    Map data = jsonDecode(weatherResult.body);

    if (data['cod'] == "404") {
      Fluttertoast.showToast(
          msg: "Please enter the recognizable city near you",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 12.0);
    }

    // weatherInfo
    List weatherData = data['list'][0]['weather'];
    Map weatherInfo = weatherData[0];
    description = weatherInfo["description"];
    main = weatherInfo["main"];
    icon = weatherInfo["icon"];

    //  Main Info like temperature
    Map mainInfo = data['list'][0]['main'];
    temperature = mainInfo['temp'];

    city = data['city']['name'];
    coord = data['city']['coord'];
    // }

    for (int i = 0; i < 40; i++) {
      mainData.add(data['list'][i]['weather'][0]['main']);
      if (data["list"][i]["dt_txt"].toString().substring(11) == '00:00:00') {
        List weatherData1 = data['list'][i]['weather'];
        Map weatherInfo1 = weatherData1[0];
        String icon1 = weatherInfo1["icon"];
        String main1 = weatherInfo1["main"];
        Map mainInfo1 = data['list'][i]['main'];
        double temperature1 = mainInfo1['temp'].toDouble();

        fiveDaysData.add({
          "icon": icon1,
          "temperature": temperature1,
          "main": main1,
          "date": data['list'][i]['dt_txt'].toString().substring(2, 11)
        });
      }
    }
  }
}
