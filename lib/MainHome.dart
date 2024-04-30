import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:misemise/changNotifier/DustProvider.dart';
import 'package:misemise/dialog/DustDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'DustMap/DustMapView.dart';
import 'mainHomeWidget/CurrentAirWidget.dart';
import 'mainHomeWidget/DustTimeWidget.dart';
import 'mainHomeWidget/DustWeekWidget.dart';
import 'mainHomeWidget/InfoWidget.dart';
import 'mainHomeWidget/LeftRightMoveWidget.dart';
import 'mainHomeWidget/MainWeather.dart';
import 'mainHomeWidget/MapWidget.dart';
import 'util/LocationUtil.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    LocationUtil.getLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Setting'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          color: Colors.white,
          onRefresh: () async {
            await context.read<DustProvider>().fetchWaitData();
          },
          child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DustMapView(context.read<DustProvider>().mapMarker)));
                  },
                  icon: Icon(Icons.map_outlined),
                ),
                IconButton(
                  onPressed: () {
                    getCaptureImage().then((value){
                      DustDialog().captureDialog(context, value, ()=> shareImage(value));
                    });
                  },
                  icon: Icon(Icons.share),
                ),
                IconButton(
                  onPressed: () {
                    print('click');
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),

            SliverList(
                delegate: SliverChildListDelegate(
                    [
                      const MainWeather(),
                      const LeftRightWidget(),
                      CurrentAirWidget(),
                      const DustTimeWidget(),
                      const DustWeekWidget(),
                      const MapWidget(),
                      const InfoWidget(),
                      const SizedBox(height: 20)
                    ]
                )
            )
          ],
        )
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

  Future<void> shareImage(Uint8List pngBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/weather.png');
    await file.writeAsBytes(pngBytes);
    await Share.shareXFiles([XFile('${directory.path}/weather.png', mimeType: 'image/png')]);
    file.delete();
  }


}
