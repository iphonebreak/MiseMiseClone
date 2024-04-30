import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerUtil {

  static Marker createMarker(double latitude, double longitude) {
    return Marker(
      markerId: MarkerId('myPosition'),
      position: LatLng(latitude, longitude),
    );
  }

  void setMarker(){

  }
}