import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:misemise/model/CurrentDust.dart';
import 'package:misemise/model/MeasuringStation.dart';
import 'package:misemise/repository/LocationAPI.dart';
import 'package:rxdart/rxdart.dart';

import '../model/Address.dart';
import '../repository/DustAPI.dart';

class DustProvider extends ChangeNotifier {
  late Position position;
  LocationAPI locationAPI = LocationAPI();
  DustAPI dustAPI = DustAPI();

  double TM_X = 0.0;
  double TM_Y = 0.0;
  MeasuringStation measuringStation = MeasuringStation();
  List<MeasuringStation> measuringStationList = [];

  CurrentDust currentDust = CurrentDust();
  List<CurrentDust> currentDustArea = []; // 전국 미세먼지
  Address address = Address();

  Set<Marker> mapMarker = {}; // 전국 지도 마커
  CurrentDust selectedMapDust = CurrentDust(); // 지도 선택 현재 미세먼지
  bool isSelectMapDust = false;

  CurrentDust dustImage = CurrentDust(); // 미세먼지 이미지

  void setPosition(Position position) {
    this.position = position;
  }

  void fetchData({Function? callback}){
    locationAPI.locationToTM(position.longitude, position.latitude).then((value) {
      this.TM_X = value['posX'];
      this.TM_Y = value['posY'];
      getMeasuringStationList();
      getCurrentAreaDust();

      dustAPI.getNearbyMsrstnList(TM_X, TM_Y).then((value) {
        measuringStation = value;

        locationAPI.locationToAddress(TM_X, TM_Y).then((value) {
          address = Address.fromJson(value);
          notifyListeners();
        });

        dustAPI.getMsrstnAcctoRltmMesureDnsty(measuringStation.stationName).then((value) {
          currentDust = value;
          notifyListeners();
          if (callback != null){
            callback();
          }
        });
      });
    });
  }

  Future<void> fetchWaitData() async {
    Map tmValue = await locationAPI.locationToTM(position.longitude, position.latitude);
    TM_X = tmValue['posX'];
    TM_Y = tmValue['posY'];
    getMeasuringStationList();
    getCurrentAreaDust();

    measuringStation = await dustAPI.getNearbyMsrstnList(TM_X, TM_Y);

    Map<String, dynamic> addressValue = await locationAPI.locationToAddress(TM_X, TM_Y);
    address = Address.fromJson(addressValue);

    currentDust = await dustAPI.getMsrstnAcctoRltmMesureDnsty(measuringStation.stationName);
    notifyListeners();

  }

  // 위도 경도를 TM 좌표로 변환하여 저장
  void setTM_Postion() {
    locationAPI.locationToTM(position.longitude, position.latitude).then((value) {
      this.TM_X = value['posX'];
      this.TM_Y = value['posY'];
    });
    notifyListeners();
  }

  // 가까운 측정소 1개 얻기
  void getMeasuringStation() {
    dustAPI.getNearbyMsrstnList(TM_X, TM_Y).then((value) {
      measuringStation = value;
      notifyListeners();
    });
  }

  // 전국 측정소 리스트 얻기
  void getMeasuringStationList() {
    dustAPI.getMsrstnList().then((stationList) {
      measuringStationList.clear();
      measuringStationList.addAll(stationList);
      notifyListeners();
    });
  }

  // 실시간 미세먼지 정보 얻기
  void getCurrentDust(){
    dustAPI.getMsrstnAcctoRltmMesureDnsty(measuringStation.stationName).then((value) {
      currentDust = value;
      notifyListeners();
    });
  }

  // 전국 실시간 미세먼지 정보 얻기
  void getCurrentAreaDust() {
    dustAPI.getCtprvnRltmMesureDnsty().then((value) {
      currentDustArea.clear();
      currentDustArea.addAll(value);
      notifyListeners();
    });
  }


  void setDustImage(CurrentDust currentDust) {
    dustImage = currentDust;
    notifyListeners();
  }

  void setMapMarker(Set<Marker> marker){
    mapMarker = marker;
  }

}