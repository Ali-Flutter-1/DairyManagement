
import 'package:dairyapp/screens/BottomNavBar/bottom_nav.dart';

import 'package:device_preview/device_preview.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(
      DevicePreview(builder: (context)=>  MyApp())

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:BottomBar() ,
    );
  }
}

