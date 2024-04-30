import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:misemise/const/MiseMiseConst.dart';
import 'package:misemise/changNotifier/DustProvider.dart';
import 'package:misemise/model/CurrentDust.dart';
import 'package:misemise/util/convert/AirValueConverUtil.dart';
import 'package:provider/provider.dart';

import 'TriangleWidget.dart';


class DustMapMarker extends StatelessWidget {

  CurrentDust dustImage = CurrentDust();
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    dustImage = context.watch<DustProvider>().dustImage;
    int airIndex = AirValueConvertUtil.getAirDustIndexValue(0, dustImage.pm10Value);

    return RepaintBoundary(
        key: _globalKey,
        child: FittedBox(
          child: Column(
            children: [
              Container(
                height: 60,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: MiseMiseConst.level8Color[AirValueConvertUtil.getAirDustIndexValue(0, dustImage.pm10Value)],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white, // 선 색상
                    width: 2, // 선 굵기
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(MiseMiseConst.level8Image[airIndex], height: 18),
                        SizedBox(width: 3),
                        Text(MiseMiseConst.level8Text[airIndex], style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold))
                      ],
                    ),
                    const Divider(color: Colors.white, thickness: 1, height: 3,),
                    Text('${dustImage.pm10Value} / ${dustImage.pm25Value}', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              TriangleWidget(MiseMiseConst.level8Color[airIndex])
            ],
          )

        )
    );
  }


  Future<Uint8List> getCaptureImage() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();

  }

}
