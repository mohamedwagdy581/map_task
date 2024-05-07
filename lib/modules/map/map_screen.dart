import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import '../../shared/network/remote/locations.dart' as locations;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late GoogleMapController mapController;
  late LatLng startLocation;
  late LatLng endLocation;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  LatLng startLocation1 =
      LatLng(40.7128, -74.0060); // Example start location (New York)
  LatLng endLocation1 =
      LatLng(34.0522, -118.2437); // Example end location (Los Angeles)

  List<LatLng> interpolatePoints(LatLng start, LatLng end, int numberOfPoints) {
    List<LatLng> points = [];

    double latStep = (end.latitude - start.latitude) / numberOfPoints;
    double lngStep = (end.longitude - start.longitude) / numberOfPoints;

    for (int i = 0; i <= numberOfPoints; i++) {
      double lat = start.latitude + (i * latStep);
      double lng = start.longitude + (i * lngStep);
      points.add(LatLng(lat, lng));
    }

    return points;
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> points = interpolatePoints(
        startLocation1, endLocation1, 10); // Interpolate 10 points
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(25)),
            child: SearchBarAnimation(
              textEditingController: TextEditingController(),
              isOriginalAnimation: true,
              enableKeyboardFocus: true,
              onExpansionComplete: () {
                debugPrint('do something just after searchbox is opened.');
              },
              onCollapseComplete: () {
                debugPrint('do something just after searchbox is closed.');
              },
              onPressButton: (isSearchBarOpens) {
                debugPrint(
                    'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
              },
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              secondaryButtonWidget: const Icon(
                Icons.close,
                size: 20,
                color: Colors.black,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(4)),
          Container(
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(25)),
            child: SearchBarAnimation(
              textEditingController: TextEditingController(),
              isOriginalAnimation: true,
              enableKeyboardFocus: true,
              onExpansionComplete: () {
                debugPrint('do something just after searchbox is opened.');
              },
              onCollapseComplete: () {
                debugPrint('do something just after searchbox is closed.');
              },
              onPressButton: (isSearchBarOpens) {
                debugPrint(
                    'do something before animation started. It\'s the ${isSearchBarOpens ? 'opening' : 'closing'} animation');
              },
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              secondaryButtonWidget: const Icon(
                Icons.close,
                size: 20,
                color: Colors.black,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(4)),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(21.512437269749487, 39.186761900782585),
                // Initial map position (Jeddah Saudi Arabia)
                zoom: 12,
              ),
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              onTap: _addMarker,
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: points,
                  color: Colors.blue,
                  width: 5,
                ),
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (startLocation != null && endLocation != null) {
            _getDirections();
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Please select both start and end locations.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.directions),
      ),
    );
  }

  void _addMarker(LatLng position) {
    setState(() {
      if (markers.length == 2) {
        markers.clear();
      }

      markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
        ),
      );

      if (markers.length == 1) {
        startLocation = position;
        print('The Position of Start Location is $startLocation');
      } else {
        endLocation = position;
        print('The Position of End Location is $endLocation');
      }
    });
  }

  Future<void> _getDirections() async {
    List<LatLng> points = interpolatePoints(
        startLocation1, endLocation1, 10); // Interpolate 10 points

    print('Get Direction Method is Called');
    String apiKey = 'AIzaSyBtq4zs01EzYsiGrNx89aApLJ6htEMGATc';
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation.latitude},${startLocation.longitude}&destination=${endLocation.latitude},${endLocation.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the JSON response and extract route information
      print('Start to fetch directions: ${response.statusCode}');
      Map<String, dynamic> data = json.decode(response.body);
      print(data);
      //List<LatLng> points = decodePoly(data['routes'][0]['overview_polyline']['points']);
      setState(() {
        polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ));
      });
      _drawRouteOnMap(points);
    } else {
      // Handle error response
      print('Failed to fetch directions: ${response.statusCode}');
    }
  }

  List<LatLng> decodePoly(String encoded) {
    List<PointLatLng> decodedPoints = PolylinePoints().decodePolyline(encoded);
    return decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  void _drawRouteOnMap(List<LatLng> points) {
    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(startLocation.toString()),
        position: startLocation,
      ));
      markers.add(Marker(
        markerId: MarkerId(endLocation.toString()),
        position: endLocation,
      ));

      Polyline polyline = Polyline(
        polylineId: PolylineId('route'),
        points: points,
        color: Colors.blue,
        width: 3,
      );

      // Add the polyline to the map
      //mapController.clearMarkers();
      //mapController.addPolyline(polyline);
    });
  }
}

// // Animated loading indicator
// Center(
// child: RotationTransition(
// turns: _animation,
// child: const Icon(
// Icons.map,
// size: 100,
// color: Colors.blue,
// ),
// ),
// ),