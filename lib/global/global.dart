import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic_side/models/mechanic_data.dart';
//import '../models/directions_details_info.dart';
//import "../models/user_models.dart";

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

Position? mechanicCurrentPosition;

MechanicData onlineMechanicData = MechanicData();

String? mechanicVehicleType = "";

//UserModel? userModelCurrentInfo;
//DirectionDetailsInfo? tripDirectionDetailsInfo;
//String userDropOfAddress = "";
