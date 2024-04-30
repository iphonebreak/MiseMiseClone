import 'package:geolocator/geolocator.dart';

class LocationUtil {

  static bool isServiceEnabled = false;

  static Future<bool> init() async {
    await Geolocator.openLocationSettings().then((value) {
      isServiceEnabled = value;
    });
    return isServiceEnabled;
  }

  static Future<bool> getLocationPermission() async {
    if (await Geolocator.isLocationServiceEnabled() == false) {
      return false;
    }

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("GPS Location 권한 수락됨");
      if (permission == LocationPermission.denied) {
        print("GPS Location 권한 거부됨");
        return false;
      } else if(permission == LocationPermission.deniedForever){
        print("GPS Location 권한 영구 거부됨");
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  static Future<Position> getLocationGPS() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}