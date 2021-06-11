import 'package:flutter/material.dart';
import 'package:travel_on_click/ui/helper/common_classes.dart';

// ignore: must_be_immutable
class Test extends StatefulWidget {
  // String sLoc;
  // String eLoc;
  // String days;
  // Test({Key? key, required this.sLoc, required this.days, required this.eLoc})
  //     : super(key: key);
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    Map totalWeatherData = ModalRoute.of(context)!.settings.arguments as Map;
    Map startLocWeatherData = totalWeatherData['startLocInfo'];
    Map endLocWeatherData = totalWeatherData['endLocInfo'];
    List weatherValues = startLocWeatherData['fiveDaysData'];
    int _index = 0;
    List weatherValues1 = endLocWeatherData['fiveDaysData1'];
    List mainData = startLocWeatherData['mainData'];
    List mainData1 = endLocWeatherData['mainData1'];

    int rainCounter0 = 0;
    for (int i = 0; i < 40; i++) {
      if (mainData[i] == "Rain") {
        rainCounter0 += 1;
      }
    }

    int rainCounter1 = 0;
    for (int i = 0; i < 40; i++) {
      if (mainData1[i] == "Rain") {
        rainCounter1 += 1;
      }
    }
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          appBar: AppBarThemeCustom(AppBarActions().appBarActions(context)),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.arrow_right),
              onPressed: () {
                Navigator.pushNamed(context, "/dir", arguments: {
                  "startCoord": startLocWeatherData['coord'],
                  "destCoord": endLocWeatherData['coord1']
                });
              }),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(children: [
                Text(
                  'Source Weather Info'.toUpperCase(),
                  style: new TextStyle(fontSize: 23.0),
                ),
                SizedBox(
                  height: 15.0,
                ),

                // Starting Location Weather Card
                WeatherCard(
                        description: startLocWeatherData['description'],
                        main: startLocWeatherData['main'],
                        temperature: startLocWeatherData['temperature'],
                        city: startLocWeatherData['name'],
                        icon: startLocWeatherData['icon'])
                    .customCardForWeather(),
                SizedBox(
                  height: 15.0,
                ),
                Center(
                  child: SizedBox(
                    height: 200,
                    // card height
                    child: PageView.builder(
                      itemCount: (startLocWeatherData['count']),
                      controller: PageController(viewportFraction: 0.7),
                      onPageChanged: (int index) =>
                          setState(() => _index = index),
                      itemBuilder: (_, i) {
                        return Transform.scale(
                          scale: i == _index ? 0.9 : 0.9,
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  '${weatherValues[i]['date']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://openweathermap.org/img/w/${weatherValues[i]['icon']}.png'), //NetworkImage
                                    radius: 30,
                                  ), //CircleAvatar
                                ),
                                Text(
                                  '${weatherValues[i]['temperature'].truncate()}\u2103',
                                  style: TextStyle(fontSize: 40),
                                ),
                                Text(
                                  weatherValues[i]['main'],
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),

                SizedBox(
                  height: 25.0,
                ),
                // Ending Location Weather Card
                Text(
                  'Destination Weather Info'.toUpperCase(),
                  style: new TextStyle(fontSize: 23.0),
                ),

                WeatherCard(
                        description: endLocWeatherData['description1'],
                        main: endLocWeatherData['main1'],
                        temperature: endLocWeatherData['temperature1'],
                        city: endLocWeatherData['name1'],
                        icon: endLocWeatherData['icon1'])
                    .customCardForWeather(),
                SizedBox(
                  height: 16.0,
                ),

                Center(
                  child: SizedBox(
                    height: 200,
                    // card height
                    child: PageView.builder(
                      itemCount: (startLocWeatherData['count']),
                      controller: PageController(viewportFraction: 0.7),
                      onPageChanged: (int index) =>
                          setState(() => _index = index),
                      itemBuilder: (_, i) {
                        return Transform.scale(
                          scale: i == _index ? 0.9 : 0.9,
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  '${weatherValues1[i]['date']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://openweathermap.org/img/w/${weatherValues1[i]['icon']}.png'), //NetworkImage
                                    radius: 30,
                                  ), //CircleAvatar
                                ),
                                Text(
                                  '${weatherValues1[i]['temperature'].truncate()}\u2103',
                                  style: TextStyle(fontSize: 40),
                                ),
                                Text(
                                  weatherValues1[i]['main'],
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: 30.0,
                ),

                Text("According to 5 days 3 hours forecast".toUpperCase(),
                    style: TextStyle(fontSize: 17, color: Colors.green)),
                SizedBox(
                  height: 15.0,
                ),

                Text(
                  "On Average".toUpperCase(),
                  style: TextStyle(fontSize: 30, color: Colors.blue),
                ),

                SizedBox(
                  height: 15.0,
                ),
                Text("Source".toUpperCase(),
                    style: TextStyle(fontSize: 20, color: Colors.green)),
                SizedBox(
                  height: 5,
                ),
                if (rainCounter0 == 0)
                  Text(
                      "No Rain!! Happy Journey to ${startLocWeatherData['name']}"),
                SizedBox(
                  height: 5,
                ),
                if (rainCounter0 > 0 && rainCounter0 < 20)
                  Text(
                      "50 percent rain, Think of trip again.. to ${startLocWeatherData['name']}"),
                SizedBox(
                  height: 5,
                ),
                if (rainCounter0 > 20)
                  Text(
                      "Heavy rain, Trip may end bad in ${startLocWeatherData['name']}"),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Destination".toUpperCase(),
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                SizedBox(
                  height: 5,
                ),
                if (rainCounter1 == 0)
                  Text(
                      "No Rain!! Happy Journey to ${endLocWeatherData['name1']}"),
                SizedBox(
                  height: 5,
                ),
                if (rainCounter1 > 0 && rainCounter1 < 20)
                  Text(
                      "50 percent rain, Think of trip again.. to ${endLocWeatherData['name1']}"),
                SizedBox(
                  height: 5,
                ),
                if (rainCounter1 > 20)
                  Text(
                      "Heavy rain, Trip may end bad in ${endLocWeatherData['name1']}"),
              ]),
            ),
          )),
    );
  }
}
