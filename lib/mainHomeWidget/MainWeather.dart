import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:misemise/changNotifier/DustProvider.dart';
import 'package:misemise/util/convert/DustValueStringUtil.dart';
import 'package:provider/provider.dart';

import '../const/MiseMiseConst.dart';

class MainWeather extends StatelessWidget {
  const MainWeather({super.key});

  @override
  Widget build(BuildContext context) {
    int dustValue = int.parse(context.watch<DustProvider>().currentDust.pm10Value == '-' ? '0' : context.watch<DustProvider>().currentDust.pm10Value);
    int index = DustValueStringUtil.getDustIndexValue(dustValue);

    log('MainWeather build index: $index, dustValue: $dustValue');

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(context.watch<DustProvider>().address.cutFullAddr(), style: TextStyle(fontSize: 30, color: Colors.white)),
          Text(context.watch<DustProvider>().currentDust.dataTime ?? '', style: TextStyle(fontSize: 20, color: Colors.white70)),
          SizedBox(height: 20),
          Image.asset(MiseMiseConst.level8Image[index], height: 150),
          SizedBox(height: 20),
          Text(DustValueStringUtil.getDustValue(dustValue), style: TextStyle(fontSize: 40, color: Colors.white)),
          Text(DustValueStringUtil.getConditionValue(dustValue), style: TextStyle(fontSize: 20, color: Colors.white)),
          SizedBox(height: 50),
        ],
      )
    );
  }
}
