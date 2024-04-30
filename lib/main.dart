import 'package:flutter/material.dart';
import 'package:misemise/const/MiseMiseConst.dart';
import 'package:misemise/SplashWidget.dart';
import 'package:misemise/util/convert/DustValueStringUtil.dart';
import 'MainHome.dart';
import 'changNotifier/DustProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DustProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    int dustValue = int.parse(context.watch<DustProvider>().currentDust.pm10Value == '-' ? '0' : context.watch<DustProvider>().currentDust.pm10Value);
    int index = DustValueStringUtil.getDustIndexValue(dustValue);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            background: MiseMiseConst.level8Color[index],
            primary: Color(0xff388e3c),
            secondary: Color(0xffc5e1a5),
            surface: Color(0xff388e3c),
            onBackground: Colors.white,
            onError: Colors.black,

        ),
      ),
      home: const SplashWidget(),

    );
  }
}




