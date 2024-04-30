import 'package:flutter/material.dart';

class DustTimeWidget extends StatelessWidget {
  const DustTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text('시간별 예보', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _dustItem(index);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _dustItem(int index){
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('오후 ${index+1}시', style: TextStyle(fontSize: 20, color: Colors.white)),
          SizedBox(height: 10),
          Image.asset('assets/icons/eight_level_big_4.png', height: 50),
          SizedBox(height: 10),
          Text('보통', style: TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
    );
  }
}
