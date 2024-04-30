import 'dart:io';

import 'package:dio/dio.dart';

class LocationAPI {

  final Dio _dio = Dio();

  LocationAPI() {
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


  // SGIS 인증
  Future<String> SGIS_Auth() async {
    Map<String, dynamic> queryParameters = {
      'consumer_key': 'consumer_key here',
      'consumer_secret': 'consumer_secret here',
    };
    Response response = await _dio.get('https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json', queryParameters: queryParameters);

    if (response.statusCode == HttpStatus.ok) {
      return response.data['result']['accessToken'];
    } else {
      return '';
    }
  }

  // 위도경도 좌표를 TM 좌표 변환
  Future<Map> locationToTM(double long, double lat) async {
    Map<String, dynamic> posX = {'posX': 0.0, 'posY': 0.0};

    String accessToken = await SGIS_Auth();
    Response response = await _dio.get('https://sgisapi.kostat.go.kr/OpenAPI3/transformation/transcoord.json?accessToken=$accessToken&src=4326&dst=5179&posX=$long&posY=$lat');

    return response.data['result'];

  }

  // TM 좌표를 주소로 변환
  Future<Map<String, dynamic>> locationToAddress(double x, double y) async {
    String accessToken = await SGIS_Auth();

    Map<String, dynamic> params = {
      'accessToken': accessToken,
      'x_coor': x,
      'y_coor': y,
      'addr_type': '20',
    };
    Response response = await _dio.get('https://sgisapi.kostat.go.kr/OpenAPI3/addr/rgeocode.json', queryParameters : params);

    return response.data['result'][0];

  }
}