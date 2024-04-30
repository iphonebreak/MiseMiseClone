import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:misemise/util/LocationUtil.dart';
import 'package:provider/provider.dart';

import 'MainHome.dart';
import 'changNotifier/DustProvider.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Color(0xff1bddac),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/icons/cloud.png', height: 150,),
                SizedBox(height: 20),
                Text('Loading...', style: TextStyle(fontSize: 15, color: Colors.white)),

              ],
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Text('MiseMise', style: TextStyle(fontSize: 13, color: Colors.white)),
            ),
            SizedBox(height: 10)
          ],
        )
      )
    );
  }

  void getData() async {
    LocationUtil.getLocationPermission();
    Position position = await LocationUtil.getLocationGPS();
    context.read<DustProvider>().setPosition(position);
    context.read<DustProvider>().fetchData(callback: ()=> goToMainHome());
  }

  void goToMainHome() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => const MainHome()),
    );
  }
}
