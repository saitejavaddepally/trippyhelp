import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_on_click/ui/helper/common_classes.dart';

import 'bookings.dart';

class Directions extends StatefulWidget {
  Directions({Key? key}) : super(key: key);

  @override
  _DirectionsState createState() => _DirectionsState();
}

late double startCoordLat;
late double startCoordLong;
late double destCoordLat;
late double destCoordLong;
Map<MarkerId, Marker> markers = {};

// PolylinePoints polylinePoints = PolylinePoints();
// Map<PolylineId, Polyline> polylines = {};

class _DirectionsState extends State<Directions> {
  // ignore: unused_field
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) async {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  // void _getPolyline() async {
  //   List<LatLng> polylineCoordinates = [];

  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyB7DfYbZCTTY1D6AzzxtB_Z3uFQP4hWcDw",
  //     PointLatLng(startCoordLat, startCoordLong),
  //     PointLatLng(startCoordLat, startCoordLong),
  //     travelMode: TravelMode.driving,
  //   );
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   } else {
  //     print(result.errorMessage);
  //   }
  //   _addPolyLine(polylineCoordinates);
  // }

  // _addPolyLine(List<LatLng> polylineCoordinates) {
  //   PolylineId id = PolylineId("poly");
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.blue,
  //     points: polylineCoordinates,
  //     width: 8,
  //   );
  //   polylines[id] = polyline;
  //   setState(() {});
  // }

  void _getNavigationData(BuildContext context) {
    Map coordsData = ModalRoute.of(context)!.settings.arguments as Map;
    startCoordLat = coordsData['startCoord']['lat'].toDouble();
    startCoordLong = coordsData['startCoord']['lon'].toDouble();
    destCoordLat = coordsData['destCoord']['lat'].toDouble();
    destCoordLong = coordsData['destCoord']['lon'].toDouble();
  }

  @override
  Widget build(BuildContext context) {
    // Determining the screen width & height
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    _getNavigationData(context);

    /// add origin marker origin marker
    _addMarker(
      LatLng(startCoordLat, startCoordLong),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(destCoordLat, destCoordLong),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    // ignore: unused_local_variable
    GoogleMapController mapcontroller;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        appBar: AppBarThemeCustom([]),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              // polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: CameraPosition(
                target: LatLng(startCoordLat, startCoordLong),
                tilt: 13.0,
                zoom: 4.5,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                mapcontroller = controller;
              },
            ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange[100], // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.book_online_rounded),
                        ),
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Booking()));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 80.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(
                            Icons.map,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async {
                          try {
                            final origin =
                                Coords(startCoordLat, startCoordLong);
                            final destination =
                                Coords(destCoordLat, destCoordLong);

                            final availableMaps =
                                await MapLauncher.installedMaps;

                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      child: Wrap(
                                        children: <Widget>[
                                          for (var map in availableMaps)
                                            ListTile(
                                              onTap: () => map.showDirections(
                                                  destination: destination,
                                                  origin: origin),
                                              title: Text(map.mapName),
                                              leading: SvgPicture.asset(
                                                map.icon,
                                                height: 30.0,
                                                width: 30.0,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
