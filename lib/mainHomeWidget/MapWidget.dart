import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:misemise/const/MiseMiseConst.dart';
import 'package:misemise/model/CurrentDust.dart';
import 'package:misemise/util/convert/AirValueConverUtil.dart';
import 'package:provider/provider.dart';

import '../DustMap/DustMapView.dart';
import '../changNotifier/DustProvider.dart';
import '../model/MeasuringStation.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Set<Marker> markers = {};
  late BitmapDescriptor bitmapDescriptor;
  late GoogleMapController _googleMapController;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: EdgeInsets.only(left: 15, top: 15), child: Text('주변 측정소 정보', style: TextStyle(fontSize: 15, color: Colors.white))),

        SizedBox(height: 2),
        Container(
          height: 300,
          margin: EdgeInsets.only(left: 5, right: 5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                 child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(context.select((DustProvider provider) => provider.position.latitude), context.select((DustProvider provider) => provider.position.longitude)),
                          zoom: 12),
                      zoomControlsEnabled: false,
                      markers: markers,
                      onMapCreated: (GoogleMapController controller) {
                        _googleMapController = controller;
                        setMarker(Provider.of<DustProvider>(context, listen: false).measuringStationList, Provider.of<DustProvider>(context, listen: false).position);
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DustMapView(markers)));
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 10, bottom: 10),
                          height: 35,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(child: Text('전체 지도 보기 >', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold))),
                        ),
                      ),
                    )
                  ],
                )

            ))

        )
      ],
    );

  }

  Future<void> setMarker(List<MeasuringStation> measuringStationList, Position position) async {
    if (measuringStationList.isEmpty) return ;

    Set<Marker> newMarkers = {};


    for (MeasuringStation station in measuringStationList) {

        newMarkers.add(
          Marker(
            markerId: MarkerId(station.stationCode.toString()),
            position: LatLng(station.dmY, station.dmX),
            icon: await getCustomMarker(station.stationCode),
          ),
        );

    }

    newMarkers.add(
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(position.latitude, position.longitude),
          icon: await getCustomMarker('1')
        )
    );

    setState(() {
      markers = newMarkers;
      context.read<DustProvider>().setMapMarker(newMarkers);
    });

  }

  // 현재 화면에 보이는 마커만 필터링하는 함수
  Future<Set<Marker>> filterMarkers(Set<Marker> newMarkers) async {
    LatLngBounds visibleRegion = await _googleMapController.getVisibleRegion();
    Set<Marker> markers = Set<Marker>.from(newMarkers);

    // 현재 화면에 보이는 마커만 선택
    Set<Marker> visibleMarkers = markers.where((marker) {
      return visibleRegion.contains(marker.position);
    }).toSet();


    return visibleMarkers;
  }



  Future<BitmapDescriptor> getCustomMarker(String stationCode) async {
    List<CurrentDust> currentDustList = Provider.of<DustProvider>(context, listen: false).currentDustArea;
    for (CurrentDust currentDust in currentDustList){
      if (currentDust.stationCode == stationCode) {
        int level = AirValueConvertUtil.getAirDustIndexValue(0, currentDust.pm10Value);
        BitmapDescriptor iconImage = await BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context), 'assets/icons/zoom1__eight_level_$level.png');
        return iconImage;
      }
    }

    return BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context), 'assets/icons/zoom1__eight_level_3.png');
  }

}
