import 'dart:io';

import 'package:dio/dio.dart';
import 'package:misemise/model/MeasuringStation.dart';

import '../model/CurrentDust.dart';

class DustAPI {

  final Dio _dio = Dio();
  static const String SERVICE_KEY = 'SERVICE_KEY_HERE';

  DustAPI() {
    _dio.options = BaseOptions(
      baseUrl: 'http://apis.data.go.kr/B552584',
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    );

    _dio.interceptors.add(
        LogInterceptor(
            responseBody: true,
            error: true,
            requestHeader: false,
            responseHeader: false,
            request: false,
            requestBody: false)
    );
  }

  // 가까운 측정소 얻기
  Future<MeasuringStation> getNearbyMsrstnList(double tmX, double tmY) async {
    Map<String, dynamic> queryParameters = {
      'serviceKey': SERVICE_KEY,
      'tmX': tmX,
      'tmY': tmY,
      'returnType': 'json',
      'ver': '1.2',

    };
    Response response = await _dio.post('/MsrstnInfoInqireSvc/getNearbyMsrstnList', queryParameters: queryParameters);

    if (response.statusCode == HttpStatus.ok) {
      return MeasuringStation.fromJson(response.data['response']['body']['items'][0]);
    } else {
      return MeasuringStation();
    }
  }

  // 측정소별 실시간 측정정보 조회
  Future<CurrentDust> getMsrstnAcctoRltmMesureDnsty(String stationName) async {
    Map<String, dynamic> queryParameters = {
      'serviceKey': SERVICE_KEY,
      'stationName': stationName,
      'numOfRows' : '5',
      'dataTerm': 'DAILY',
      'returnType': 'json',
      'ver': '1.4',
    };
    Response response = await _dio.get('/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty', queryParameters: queryParameters);
    if (response.statusCode == HttpStatus.ok) {
      return CurrentDust.fromJson(response.data['response']['body']['items'][0]);
    } else {
      return CurrentDust();
    }
  }

  // 전국 실시간 측정정보 조회
  Future<List<CurrentDust>> getCtprvnRltmMesureDnsty() async {
    List<CurrentDust> currentDustList = [];

    Map<String, dynamic> queryParameters = {
      'serviceKey': SERVICE_KEY,
      'sidoName': '전국',
      'numOfRows' : '659',
      'returnType': 'json',
      'ver': '1.4',
    };
    Response response = await _dio.get('/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty', queryParameters: queryParameters);
    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> items = response.data['response']['body']['items'];
      for (Map<String, dynamic> item in items) {
        currentDustList.add(CurrentDust.fromJson(item));
      }
      return currentDustList;
    } else {
      return currentDustList;
    }
  }

  // 전국 측정소 조회
  Future<List<MeasuringStation>> getMsrstnList() async {
    List<MeasuringStation> stationList = [];

    Map<String, dynamic> queryParameters = {
      'serviceKey': SERVICE_KEY,
      'returnType': 'json',
      'ver' : '1.1',
      'numOfRows' : '659',
    };
    Response response = await _dio.get('/MsrstnInfoInqireSvc/getMsrstnList', queryParameters: queryParameters);
    if (response.statusCode == HttpStatus.ok) {
      try {
        List<dynamic> items = response.data['response']['body']['items'];

        for (Map<String, dynamic> item in items) {
          stationList.add(MeasuringStation.fromJson(item));
        }
      } catch (e) {
        return stationList;
      }

      return stationList;
    } else {
      return stationList;
    }
  }


}