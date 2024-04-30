import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:misemise/const/MiseMiseConst.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';

import '../util/convert/AirValueConverUtil.dart';

class DustDialog {

  static void show(context, bool isMicroDust, value){
    int airIndex = AirValueConvertUtil.getAirDustIndexValue(isMicroDust ? 1 : 0, value);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 300,

            child: Stack(
              children: [
                Positioned(
                    top: (size.height * .1) / 2,
                    child: Container(
                      height: size.height * .5,
                      width: size.width * .9,
                      color: Colors.white,
                    )
                ),
                Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        child: Positioned(top:-50, left: 0, right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MiseMiseConst.level8Color[airIndex],
                                border: Border.all(
                                  color: MiseMiseConst.level8Color[airIndex],
                                  width: 10,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Image.asset(MiseMiseConst.level8Image[airIndex], height: 50),
                            )
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(isMicroDust ? '초미세먼지' : '미세먼지', style: TextStyle(fontSize: 20, color: Colors.grey)),
                          SizedBox(width: 5),
                          Text(MiseMiseConst.level8Text[airIndex], style: TextStyle(fontSize: 20, color: MiseMiseConst.level8Color[airIndex], fontWeight: FontWeight.bold)),
                        ],
                      ),

                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Image.asset(MiseMiseConst.graph_pm10_image[airIndex], height: 80),
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey),
                      TextButton(onPressed: (){Navigator.pop(context);}, child: Text('확인', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)))
                    ]
                )
              ],
            )


          ),

        );
      },
    );
  }

  void captureDialog(context, Uint8List bytes, Function btnCallback) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(10),
              insetPadding: EdgeInsets.symmetric(horizontal: 0),
              backgroundColor: Colors.white,
              content: Container(
                width: 200,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(bytes, width: double.maxFinite, fit: BoxFit.cover),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: ()=> btnCallback(),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(300, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: Color(0xff4DD6D3),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('위 화면 공유하기')
                      )
                      )
                    ],
                  )
              )
          );
        }
    );
  }

  static void showImageDialog(BuildContext context, image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 0),
        content: GestureDetector(
          child: Container(
            child: Image.memory(
              image,
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}