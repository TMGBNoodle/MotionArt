import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:motion_art/SensorClass/sensor_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motion Art',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Motion Art'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Sensordata sensor = Sensordata();
  int _counter = 0;
  double posX = 0;
  double posY = 0;
  double posZ = 0;
  final _offsets = <Offset>[];

  void updateVals() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _counter++;
      posX = sensor.xPos;
      posY = sensor.yPos;
      posZ = sensor.zPos;
    });
  }
  late Timer _timer;

  get background => null;
  @override
  void initState() {
    super.initState();
    _timer =Timer.periodic(const Duration(milliseconds: 200), (Timer timer){
      updateVals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          onPanStart: (details) {
            print("Global position is: ${details.globalPosition}");
            setState(() {
              _offsets.add(details.globalPosition);
            });
          },
            onPanUpdate: (details) {
            setState(() {
              _offsets.add(details.globalPosition);
            });
        },
            onPanEnd: (details) {
            setState(() {
              _offsets.add(Offset(0, 0));
            });
            },
          child: CustomPaint(
            painter: MotionPainter(_offsets),
            child: Container(
              height: 300,
              width: 300,
              color: Colors.pink,
              child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Test the Motion Draw App!',
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                        "$posX, $posY, $posZ"
                    ),
                  ],
               ),
            )
            )
          )
        ),
      );
  }
}

class MotionPainter extends CustomPainter {
  final offsets;

  MotionPainter(this.offsets) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color=Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;
    for (var offset in offsets) {
      print("Offset: ${offset}");
      canvas.drawPoints(
          PointMode.points, offsets, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
