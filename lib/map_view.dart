import 'dart:async';
import 'package:campus_food/new_pin_creator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'place_data.dart';
import 'place_view.dart';
import './auth.dart';

class MapView extends StatefulWidget {
  @override
  MapViewState createState() => MapViewState();
}

Place nave = new Place(
  "North Ave",
  "Dining Hall",
  new DateTime(2019, 10, 27),
  LatLng(33.771261, -84.391391),
  25,
  null,
  "a01",
  null
);

class MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 5.0;
  Map<String, Place> places = {};
  List<Marker> allMarkers = [];
  List<String> addedDiningOptions = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
        ],
      ),
    );
  }

  Widget _zoomminusfunction() {
    return Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(Icons.zoom_out),
          onPressed: () {
            _minus(zoomVal--);
          },
        )
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(Icons.zoom_in),
          onPressed: () {
            _plus(zoomVal++);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(33.777281, -84.398600), zoom: zoomVal)));
  }
  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(33.777281, -84.398600), zoom: zoomVal)));
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: _buildMap(context),
    );
  }

  Future<void> _gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }

  Widget _buildMap(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection("places")
          .where("timeToExpire", isGreaterThan: DateTime.now().millisecondsSinceEpoch)
          .snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData)
          return new Text("Connecting...");
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:  CameraPosition(target: LatLng(33.776817, -84.398879), zoom: 12),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set.from(_buildMarkers(context, snapshot.data.documents)),
          zoomGesturesEnabled: true,
          onLongPress: (latlng) {
            if(Auth.user != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => (NewPinCreator(latlng)))
              );
            } else {
              Auth.refreshFirebaseUser();
              Auth.SignInAlert(context, "You can't create a new dining location without signing in first.");
            }
          },
        );
      }
    );
  }

    Marker _buildMarker(BuildContext context, DocumentSnapshot data) {
      Place place = Place.fromSnapshot(data);
      places[place.id] = place;
      return Marker(
          markerId: MarkerId(place.id),
          position: place.location,
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.type,
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (PlaceView(place)),
                )
            );
          }
      );
    }

  List<Marker> _buildMarkers(BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildMarker(context, data)).toList();
  }



}