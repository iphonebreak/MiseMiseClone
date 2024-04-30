import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:misemise/DustMap/DustMapMarker.dart';
import 'package:misemise/const/MiseMiseConst.dart';
import 'package:misemise/util/convert/AirValueConverUtil.dart';
import 'package:provider/provider.dart';

import '../changNotifier/DustProvider.dart';
import '../model/CurrentDust.dart';
import '../model/MeasuringStation.dart';

enum MarkerType {
  DEFAULT,
  DUST_DETAIL,
  SMALL
}

class DustMapView extends StatefulWidget {
  Set<Marker> markers = {};
  DustMapView(this.markers, {super.key});

  @override
  State<DustMapView> createState() => _DustMapViewState();
}

class _DustMapViewState extends State<DustMapView> {
  double previousZoomLevel = 0;
  LatLng previousPosition = LatLng(0, 0);
  MarkerType currentMarkerType = MarkerType.DEFAULT;

  List<CurrentDust> filteredCurrentDustList = [];
  CurrentDust selectCurrentDust = CurrentDust();
  DustMapMarker dustMapMarker = DustMapMarker();

  Set<Marker> dustMarkerList = {};
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('지도'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {

            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            dustMapMarker,
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(context.select((DustProvider provider) => provider.position.latitude), context.select((DustProvider provider) => provider.position.longitude)),
                  zoom: 12),
              zoomControlsEnabled: false,
              markers: dustMarkerList,
              onCameraMove: _onCameraZoom,
              onMapCreated: (controller) {
                _controller = controller;
                updateMarker(MarkerType.DEFAULT);
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                ),
                child: Text('독도'), onPressed: () {
                _controller.animateCamera(
                    CameraUpdate.newLatLng(
                        const LatLng(37.243278, 131.866842)
                    )
                );
              },
              )
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                    ),
                    onPressed: () {
                      _controller.animateCamera(CameraUpdate.zoomIn());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                    ),
                    onPressed: () {
                      _controller.animateCamera(CameraUpdate.zoomOut());
                    },
                  )
                ],
              )
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                  ),
                  icon: Icon(Icons.my_location), onPressed: () {
                    _controller.animateCamera(
                        CameraUpdate.newLatLng(
                            LatLng(Provider.of<DustProvider>(context, listen: false).position.latitude, Provider.of<DustProvider>(context, listen: false).position.longitude)
                        )
                    );
                },
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:
              Visibility(
                visible: selectCurrentDust.stationName.isNotEmpty,
                child: infoDustPopup(context, selectCurrentDust)
              )
            )
          ],
        )

      )
    );
  }

  void _onCameraZoom(CameraPosition position) {
    if (position.zoom == 0.0) return;
    MarkerType newMarkerType; // 새로운 마커 타입을 결정할 변수

    // 현재 줌 레벨에 따라 새로운 마커 타입을 결정
    if (position.zoom < 10 && previousZoomLevel >= 10) {
      newMarkerType = MarkerType.SMALL;
    } else if ((position.zoom >= 10 && position.zoom <= 12) && previousZoomLevel < 10) {
      newMarkerType = MarkerType.DEFAULT;
    } else if (position.zoom > 13 && previousZoomLevel <= 13) {
      newMarkerType = MarkerType.DUST_DETAIL;
    } else {
      newMarkerType = currentMarkerType;
    }

    // 이전 마커 타입과 새로운 마커 타입이 다른 경우에만 업데이트하고 출력
    if (newMarkerType != currentMarkerType) {
      updateMarker(newMarkerType);
      print('zoom level: $newMarkerType');
      currentMarkerType = newMarkerType;
    }
    previousZoomLevel = position.zoom;

    if (position.zoom != previousZoomLevel || position.target != previousPosition) {
      if (position.zoom >= 13){
        return;
      }
      updateMarker(currentMarkerType);
    }

    previousPosition = position.target;
  }


  // 아이콘 생성
  Future<BitmapDescriptor> getCustomMarkerIcon(String stationCode, MarkerType type) async {
    //List<CurrentDust> currentDustList = Provider.of<DustProvider>(context, listen: false).currentDustArea;

    for (CurrentDust currentDust in filteredCurrentDustList){
      if (currentDust.stationCode == stationCode) {
        int level = AirValueConvertUtil.getAirDustIndexValue(0, currentDust.pm10Value);
        BitmapDescriptor iconImage;

        if (type == MarkerType.SMALL) {
          iconImage = await BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context), 'assets/icons/zoom0__eight_level_$level.png');
        } else if (type == MarkerType.DUST_DETAIL) {
          context.read<DustProvider>().setDustImage(currentDust);
          iconImage = BitmapDescriptor.fromBytes(await dustMapMarker.getCaptureImage());
        } else if (type == MarkerType.DEFAULT) {
          iconImage = await BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context), 'assets/icons/zoom1__eight_level_$level.png');
        } else {
          iconImage = await BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context), 'assets/icons/zoom1__eight_level_$level.png');
        }
        return iconImage;
      }
    }

    return BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context), 'assets/icons/minimap_my_location.png');
  }

  void updateMarker(MarkerType type) async {
    if (widget.markers.isEmpty) return;
    List<CurrentDust> currentDustList = Provider.of<DustProvider>(context, listen: false).currentDustArea;

    Set<Marker> newMarkers = {};
    Set<Marker> filteredMarkers = await filterMarkers(currentDustList);

    for (final Marker marker in filteredMarkers){
      final newMarker = marker.copyWith(
          iconParam: await getCustomMarkerIcon(marker.markerId.value, type),
          onTapParam: () {
            setState(() {
              selectCurrentDust = currentDustList.firstWhere((element) => element.stationCode == marker.markerId.value);
            });
          }
      );
      newMarkers.add(newMarker);
    }

    setState(() {
      dustMarkerList = newMarkers;
    });
  }

  // 현재 화면에 보이는 마커만 필터링하는 함수
  Future<Set<Marker>> filterMarkers(List<CurrentDust> currentDustList) async {
    LatLngBounds visibleRegion = await _controller.getVisibleRegion();
    Set<Marker> markers = Set<Marker>.from(widget.markers);

    // 현재 화면에 보이는 마커만 선택
    Set<Marker> visibleMarkers = markers.where((marker) {
      return visibleRegion.contains(marker.position);
    }).toSet();

    filteredCurrentDustList = currentDustList.where((currentDust) {
      return visibleMarkers.map((e) => e.markerId.value).contains(currentDust.stationCode);
    }).toList();

    return visibleMarkers;
  }

  // 마커 클릭시 지도 아래 정보
  Widget infoDustPopup(BuildContext context, CurrentDust currentDust) {

    return GestureDetector(
      onTap: () {
        setState(() {
          selectCurrentDust.stationName = '';
        });
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: MiseMiseConst.level8Color[AirValueConvertUtil.getAirDustIndexValue(0, currentDust.pm10Value)],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(MiseMiseConst.level8Image[AirValueConvertUtil.getAirDustIndexValue(0, currentDust.pm10Value)], width: 50),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentDust.stationName, style: TextStyle(fontSize: 13, color: Colors.white)),
                    Text(MiseMiseConst.level8Text[AirValueConvertUtil.getAirDustIndexValue(0, currentDust.pm10Value)], style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('미세먼지', style: TextStyle(fontSize: 12, color: Colors.white)),
                Row(children: [
                  Text(MiseMiseConst.level8Text[AirValueConvertUtil.getAirDustIndexValue(0, currentDust.pm10Value)], style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold )),
                  SizedBox(width: 5),
                  Text('${currentDust.pm10Value}${MiseMiseConst.airUnit[0]}', style: TextStyle(fontSize: 12, color: Colors.white)),
                ]),
                SizedBox(height: 5),
                Text('초미세먼지', style: TextStyle(fontSize: 12, color: Colors.white)),
                Row(
                  children: [
                    Text(MiseMiseConst.level8Text[AirValueConvertUtil.getAirDustIndexValue(0, currentDust.pm25Value)], style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(width: 5),
                    Text('${currentDust.pm25Value}${MiseMiseConst.airUnit[0]}', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                )

              ],
            ),
          ],
        ))
      );

  }
}
