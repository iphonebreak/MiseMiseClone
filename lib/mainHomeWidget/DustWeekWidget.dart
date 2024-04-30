import 'package:flutter/material.dart';

class DustWeekWidget extends StatelessWidget {
  const DustWeekWidget({super.key});

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
              child: Text('일별 예보', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _dustItem();
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );

  }

  Widget _dustItem(){
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('금요일 아침', style: TextStyle(fontSize: 13, color: Colors.white)),
          SizedBox(height: 3),
          Image.asset('assets/icons/eight_level_big_4.png', height: 20),
          SizedBox(height: 3),
          Text('보통', style: TextStyle(fontSize: 13, color: Colors.white)),
        ],
      ),
    );
  }
}
