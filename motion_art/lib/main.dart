import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:motion_art/SensorClass/sensor_data.dart';
import 'package:motion_art/pages/draw.dart';
import 'package:motion_art/pages/title.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "TitlePage",
      routes: {
        "TitlePage": (context) => TitlePage(),
        "DrawPage": (context) => const DrawPage()
      },
    );
  }
}
