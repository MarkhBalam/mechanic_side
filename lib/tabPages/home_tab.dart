import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mechanic_side/Assistants/assistant_methods.dart';
import 'package:mechanic_side/global/global.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;
  bool isMechanicActive = false;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateMechanicPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    mechanicCurrentPosition = cPosition;

    LatLng LatLngPosition = LatLng(
        mechanicCurrentPosition!.latitude, mechanicCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: LatLngPosition, zoom: 15);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            mechanicCurrentPosition!, context);
    print("This is our address = " + humanReadableAddress);
  }

  readCurrentMechanicInformation() async {
    currentUser = firebaseAuth.currentUser;
    FirebaseDatabase.instance
        .ref()
        .child("Mechanic")
        .child(currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlineMechanicData.id = (snap.snapshot.value as Map)["id"];
        onlineMechanicData.name =
            (snap.snapshot.value as Map)["mechanic_details"]["name"];
        onlineMechanicData.car_number =
            (snap.snapshot.value as Map)["mechanic_details"]["car_number"];
        onlineMechanicData.car_model =
            (snap.snapshot.value as Map)["mechanic_details"]["car_model"];

        mechanicVehicleType =
            (snap.snapshot.value as Map)["mechanic_details"]["type"];
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfLocationPermissionAllowed();
    readCurrentMechanicInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 40),
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);

            newGoogleMapController = controller;

            locateMechanicPosition();
          },
        ),
        //ui for online/offline mechine
        statusText != "Now Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black87,
              )
            : Container(),

        //botton for online/offine mechanic
        Positioned(
          top: statusText != "Now Online"
              ? MediaQuery.of(context).size.height * 0.45
              : 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (isMechanicActive != true) {
                      mechanicIsOnlineNow();
                      updateMechanicLocationAtRealTime();

                      setState(() {
                        statusText = "Now Online";
                        isMechanicActive = true;
                        buttonColor = Colors.transparent;
                      });
                    } else {
                      mechanicIsOfflineNow();
                      setState(() {
                        statusText = "Now offline";
                        isMechanicActive = false;
                        buttonColor = Colors.grey;
                      });
                      Fluttertoast.showToast(msg: "You are offline now");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      )),
                  child: statusText != "Now Online"
                      ? Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.phonelink_ring,
                          color: Colors.white,
                          size: 26,
                        )),
            ],
          ),
        ),
      ],
    );
  }

  mechanicIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    mechanicCurrentPosition = pos;
    Geofire.initialize("activeMechanic");
    Geofire.setLocation(currentUser!.uid, mechanicCurrentPosition!.latitude,
        mechanicCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("mechanic")
        .child(currentUser!.uid)
        .child("newRideStatus");
    ref.set("idle");
    ref.onValue.listen((event) {});
  }

  updateMechanicLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      if (isMechanicActive == true) {
        Geofire.setLocation(currentUser!.uid, mechanicCurrentPosition!.altitude,
            mechanicCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(mechanicCurrentPosition!.latitude,
          mechanicCurrentPosition!.longitude);

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  mechanicIsOfflineNow() {
    Geofire.removeLocation(currentUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("mechanic")
        .child(currentUser!.uid)
        .child("newRideStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(Duration(milliseconds: 2000), () {
      SystemChannels.platform.invokeMapMethod("SystemNavigator.pop");
    });
  }
}
