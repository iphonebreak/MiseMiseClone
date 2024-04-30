import 'package:flutter/material.dart';
import 'package:misemise/const/MiseMiseConst.dart';
import 'package:misemise/changNotifier/DustProvider.dart';
import 'package:misemise/util/convert/AirValueConverUtil.dart';
import 'package:misemise/util/convert/DustValueStringUtil.dart';
import 'package:provider/provider.dart';

import '../dialog/DustDialog.dart';

class CurrentAirWidget extends StatelessWidget {
  CurrentAirWidget({super.key});
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      height: 150,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
                child:Container(
                  margin: EdgeInsets.only(left: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(padding: EdgeInsets.all(10), child: Image.asset('assets/icons/left_arrow.png', width: 10)),
                  ),
              )
            ),

            Expanded(child:
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, groupIndex) {
                  return Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                        int itemIndex = groupIndex * 3 + index;
                        if (itemIndex < MiseMiseConst.airType.length) {
                          return _airItem(context, itemIndex);
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    )
                  );

                },
              )
            ),

            GestureDetector(
              onTap: () {
                _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
              child:Container(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(padding: EdgeInsets.all(10), child: Image.asset('assets/icons/right_arrow.png', width: 10)),
                ),
            )),
      ])
      )
    );
  }

  Widget _airItem(BuildContext context, int index){
    String airValue = context.watch<DustProvider>().currentDust.getAirType()[index];
    int airConditionIndex = AirValueConvertUtil.getAirDustIndexValue(index, airValue.toString());

    return GestureDetector(
      onTap: () {
        DustDialog.show(context, index == 1, airValue);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(MiseMiseConst.airType[index], style: TextStyle(fontSize: 15, color: Colors.white)),
            SizedBox(height: 5),
            Image.asset(MiseMiseConst.level8Image[airConditionIndex], height: 40),
            SizedBox(height: 5),
            Text(MiseMiseConst.level8Text[airConditionIndex], style: TextStyle(fontSize: 15, color: Colors.white)),
            Text('$airValue${MiseMiseConst.airUnit[index]}', style: TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
      )
    );
  }
}
