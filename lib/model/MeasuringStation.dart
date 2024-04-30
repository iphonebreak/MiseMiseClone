class MeasuringStation {
  String stationName = '';
  String stationCode = '';
  String addr = '';
  double tm = 0.0; // 요청한 TM좌표와 측정소간의 거리(km 단위)
  double dmX = 0.0; // 측정소의 X 좌표
  double dmY = 0.0; // 측정소의 Y 좌표

  MeasuringStation();

  MeasuringStation.fromJson(Map<String, dynamic> json) {
    stationName = json['stationName'];
    stationCode = json['stationCode'];
    addr = json['addr'];
    tm = json['tm'] ?? 0.0;
    dmX = double.parse(json['dmX'] ?? '0.0');
    dmY = double.parse(json['dmY'] ?? '0.0');
  }


}