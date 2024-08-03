import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mechanic_side/Assistants/request_assistant.dart';
import 'package:mechanic_side/models/directions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic_side/global/map_key.dart';
//import 'package:garage_finder/models/directions.dart';

class AssistantMethods {
  /* static void readCurrentOnlineInfo() async{
  currentUser = firebaseAuth.currentUser;
  DatabaseReference userRef = FireBaseDatabase.instance
   .ref
   .child("users")
   .child(currentUser!.uid);
  
  userRef.once().then((snap)){
    if(snap.snapshot.value != null){
      userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
    }
  }
  }*/
  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key = $mapkey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occured. Failed No Response ") {
      humanReadableAddress = requestResponse["results"][0]["fomatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      //Provider.of<AppInfo>(context,Listen:false).updatePickupLocationAddress(userPickUpAddress)
    }

    return humanReadableAddress;
  }
}
