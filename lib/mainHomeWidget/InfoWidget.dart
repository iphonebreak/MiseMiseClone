import 'package:flutter/material.dart';
import 'package:misemise/changNotifier/DustProvider.dart';
import 'package:provider/provider.dart';


class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('기본정보', style: TextStyle(fontSize: 15, color: Colors.white60)),
          SizedBox(height: 10),
          rowItem('업데이트 시간'.padRight(15), context.watch<DustProvider>().currentDust.dataTime ?? ''),
          rowItem('통합지수 값'.padRight(17), '${context.watch<DustProvider>().currentDust.khaiValue} unit', is24HourStr: true),
          rowItem('통합지수 상태'.padRight(15), getKhaiGrade(context), is24HourStr: true),

          SizedBox(height: 20),
          Text('측정소 이름 | 측정망 분류', style: TextStyle(fontSize: 15, color: Colors.white60)),
          SizedBox(height: 10),
          rowItem('PM10'.padRight(20), '${context.watch<DustProvider>().currentDust.stationName} | ${context.watch<DustProvider>().currentDust.mangName}'),
          rowItem('PM2.5'.padRight(20), '${context.watch<DustProvider>().currentDust.stationName} | ${context.watch<DustProvider>().currentDust.mangName}'),
          rowItem('NO2'.padRight(22), context.watch<DustProvider>().currentDust.stationName),
          rowItem('O3'.padRight(23), context.watch<DustProvider>().currentDust.stationName),
          rowItem('CO'.padRight(23), context.watch<DustProvider>().currentDust.stationName),
          SizedBox(height: 20),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.white60, size: 25),
              SizedBox(width: 10),
              Flexible(
                child: Text('미세미세는 한국환경공단(에어코리아)과 기상청에서 제공하는 정보를 바탕으로 합니다. 다양한 변수(교통량, 공장 가동률 등)로 인해 실제 대기농도와 차이가 있을 수 있습니다.', style: TextStyle(fontSize: 12, color: Colors.white70))
              ),
            ],
          )
        ],

      ),
    );
  }

  Row rowItem(String title, String value, {bool is24HourStr = false}){
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 15, color: Colors.white70)),
        Text(value, style: TextStyle(fontSize: 15, color: Colors.white)),
        is24HourStr ? SizedBox(width: 8) : SizedBox(),
        is24HourStr ? Text('최근 24시간 평균', style: TextStyle(fontSize: 13, color: Colors.white70)) : SizedBox(),
      ],
    );
  }

  String getKhaiGrade(BuildContext context){
    String khaiGrade = '';
    String khaiValue = context.watch<DustProvider>().currentDust.khaiValue.trim();
    if (khaiValue.isEmpty || khaiValue == '-') return '정보없음';

    int khaiValueNum = int.parse(khaiValue);
    if(khaiValueNum >= 0 && khaiValueNum <= 50){
      khaiGrade = '좋음';
    }else if(khaiValueNum >= 51 && khaiValueNum <= 100){
      khaiGrade = '보통';
    }else if(khaiValueNum >= 101 && khaiValueNum <= 250){
      khaiGrade = '나쁨';
    }else if(khaiValueNum >= 251){
      khaiGrade = '매우나쁨';
    }
    return khaiGrade;
  }
}
