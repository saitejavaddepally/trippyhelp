import 'package:flutter/material.dart';
import 'package:travel_on_click/ui/helper/common_classes.dart';
import 'package:url_launcher/url_launcher.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarThemeCustom([]),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  onTap: () async {
                    const url = 'https://makemytrip.com';
                    if (await canLaunch(url)) {
                      await launch(url, forceSafariVC: false);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  leading: Icon(Icons.book_online_outlined),
                  trailing: Text(
                    "",
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                  title: Text("make my trip".toUpperCase()));
            }),
      ),
    );
  }
}
