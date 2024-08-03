import 'dart:async';
import 'package:mechanic_side/Assistants/assistant_methods.dart';

import 'package:geocoder2/geocoder2.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic_side/global/map_key.dart';
import 'package:mechanic_side/models/directions.dart';

class map_page1 extends StatefulWidget {
  const map_page1({super.key});

  @override
  State<map_page1> createState() => _map_page1State();
}

class _map_page1State extends State<map_page1> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controlleGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _LocationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userNmae = "";
  String userEmail = "";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  get darkTheme => null;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng LatLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: LatLngPosition, zoom: 15);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            userCurrentPosition!, context);
    print("This is our address = " + humanReadableAddress);

    //userName = userModelCurrentInfo!.name!;
    //userEmail = userModelCurrentInfo!.email;

    //initializeGeoFireListener();
    //AssistantMethods.readTripsKeysForOnlinerUser(context)
  }

  /*getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: mapkey);
      setState(() {
        _address = data.address;
      });
    } catch (e) {
      print(e);
    }
  }*/

  checkIfLocationPermissionAllowed() async {
    _LocationPermission = await Geolocator.requestPermission();

    if (_LocationPermission == LocationPermission.denied) {
      _LocationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controlleGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {});

                locateUserPosition();
              },
              /*onCameraMove: (CameraPosition? position) {
                if (pickLocation != position!.target) {
                  setState(() {
                    pickLocation = position.target;
                  });
                }
              },
              onCameraIdle: () {
                getAddressFromLatLng();
              },*/
            ),
            /* Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                /* child: Image.asset(
                    "images/carlift_icon.png",
                    height: 45,
                    width: 45,
                  )*/
              ),
            ),*/
            Positioned(
              top: 40,
              right: 20,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(20),
                child: Text(
                  _address ?? "Set your pickuplocation",
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    SizedBox(
      height: 5,
    );
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            //Navigator.push(context,MaterialPageRoute(builder: (c) => PrecisePickUpscreen()));
          },
          child: Text(
            "Pick Up",
            style: TextStyle(color: darkTheme ? Colors.black : Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            "Resquest Mechine",
            style: TextStyle(color: darkTheme ? Colors.black : Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
        ),
      ],
    );
  }
}
