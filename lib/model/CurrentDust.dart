class CurrentDust {
  String dataTime = ''; // 오염도측정 연-월-일 시간: 분
  String stationName = ''; // 측정소 이름
  String stationCode  = ''; // 측정소 코드 값
  String mangName = ''; //측정망 정보(도시대기, 도로변대기, 국가배경농도, 교외대기, 항만)
  String so2Value = ''; // 아황산가스 농도
  String coValue = ''; // 일산화탄소 농도
  String o3Value = ''; // 오존 농도
  String no2Value = ''; // 이산화질소 농도
  String pm10Value = '0'; // 미세먼지(PM10) 농도
  String pm10Value24 = ''; // 미세먼지(PM10) 24시간 예측 이동 농도
  String pm25Value = ''; // 미세먼지(PM2.5)  농도
  String pm25Value24 = ''; // 미세먼지(PM2.5) 24시간예측이동농도

  String khaiValue = '0'; // 통합대기환경수치
  String khaiGrade = '0'; // 통합대기환경지수
  String so2Grade = '0'; // 아황산가스 지수
  String coGrade = '0'; // 일산화탄소 지수
  String o3Grade = '0'; // 오존 지수
  String no2Grade = '0'; // 이산화질소 지수
  String pm10Grade = '0'; // 미세먼지(PM10) 24시간 등급자료

  String pm25Grade = ''; // 미세먼지(PM2.5)24시간 등급자료

  String pm10Grade1h = ''; // 미세먼지(PM10) 1시간 등급자료

  String pm25Grade1h = ''; // 미세먼지(PM2.5) 1시간 등급자료

  String so2Flag = ''; // 측정자료 상태정보(점검및교정,장비점검,자료이상,통신장애)
  String coFlag = ''; // 측정자료 상태정보(점검및교정,장비점검,자료이상,통신장애)
  String o3Flag = ''; // 측정자료 상태정보(점검및교정,장비점검,자료이상,통신장애)
  String no2Flag = ''; // 측정자료 상태정보(점검및교정,장비점검,자료이상,통신장애)
  String pm10Flag = ''; // 측정자료 상태정보(점검및교정,장비점검,자료이상,통신장애)
  String pm25Flag = ''; // 측정자료 상태정보(점검및교정,장비점검,자료이상,통신장애)

  CurrentDust();

  CurrentDust.fromJson(Map<String, dynamic> json) {
    dataTime = json['dataTime']?? '';
    stationName = json['stationName']?? '';
    stationCode = json['stationCode']?? '';
    mangName = json['mangName']?? '';
    so2Value = json['so2Value']?? '0';
    coValue = json['coValue']?? '0';
    o3Value = json['o3Value']?? '0';
    no2Value = json['no2Value']?? '0';
    pm10Value = json['pm10Value']?? '0';
    pm10Value24 = json['pm10Value24']?? '0';
    pm25Value = json['pm25Value']?? '0';
    pm25Value24 = json['pm25Value24']?? '0';
    khaiValue = json['khaiValue']?? '0';
    khaiGrade = json['khaiGrade'] ?? '0';
    so2Grade = json['so2Grade']?? '';
    coGrade = json['coGrade']?? '';
    o3Grade = json['o3Grade']?? '';
    no2Grade = json['no2Grade']?? '';
    pm10Grade = json['pm10Grade'] ?? '';
    pm25Grade = json['pm25Grade'] ?? '';
    pm10Grade1h = json['pm10Grade1h'] ?? '';
    pm25Grade1h = json['pm25Grade1h'] ?? '';
    so2Flag = json['so2Flag'] ?? '0';
    coFlag = json['coFlag']?? '0';
    o3Flag = json['o3Flag']?? '0';
    no2Flag = json['no2Flag']?? '0';
    pm10Flag = json['pm10Flag']?? '0';
    pm25Flag = json['pm25Flag']?? '0';
  }

  List<String> getAirType() {
    return [
      this.pm10Value ?? '0',
      this.pm25Value ?? '0',
      this.no2Value ?? '0',
      this.o3Value ?? '0',
      this.coValue ?? '0',
      this.so2Value ?? '0',
    ];
  }
}