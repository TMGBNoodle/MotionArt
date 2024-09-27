

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:motion_art/SensorClass/sensor_data.dart';

class DrawPage extends StatefulWidget {

  const DrawPage({super.key});

  @override 
  State<DrawPage> createState() => DrawPageState();

} 

class DrawPageState extends State<DrawPage> {
  Sensordata sensor = Sensordata();
  //int _counter = 0;
  double xPosOffset = 150;
  double yPosOffset = 300;
  double posX = 0;
  double posY = 0;
  double posZ = 0;
  final _offsets = <Offset>[];
  List<double>? xyz;
  List<Offset> positions = [];
  bool canDraw = false;

  void updateVals() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      //_counter++;
      xyz = sensor.grabXYZ();
      canDraw = sensor.zeroFlag;
      posX = xyz![0];
      posY = -xyz![1];
      posZ = xyz![2];
      positions.add(Offset(posX + xPosOffset, posY + yPosOffset));
    });
  }
  late Timer _timer;

  String buttonText() {
    if (canDraw) {
      return "Please don't move the phone, calibrating";
    } return "Calibrated";
  }

  get background => null;
  @override
  void initState() {
    super.initState();
    xyz = sensor.grabXYZ();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer){
      updateVals();
    });
  }

  void maybeSetState() {
    if (canDraw) {
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Draw Page"),
      ),
      body: Column(
        children: <Widget>[
          Expanded( 
            child: Center( 
              child: GestureDetector(
                onPanStart: (details) {
                  maybeSetState();
                },
                  onPanUpdate: (details) {
                  maybeSetState();
                },
                  onPanEnd: (details) {
                  maybeSetState();
                },
              child: CustomPaint(
                painter: MotionPainter(_offsets, positions),
                child: Container(
                  height: 300,
                  width: 300,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Test the Motion Draw App!',
                      ), Text("$posX, $posY, $posZ")
                    ]
                  )
                ),
              )
            ),
          )
        ), const Spacer(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() { canDraw = !canDraw; });
            },
            child: Text(buttonText()),
          ),
        ),
      ])
    );
  }
}

class MotionPainter extends CustomPainter {
  final offsets;
  var positions;
  MotionPainter(this.offsets, this.positions) : super();

  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint()
    //   ..color=Colors.black
    //   ..strokeCap = StrokeCap.round
    //   ..strokeWidth = 5;

    final otherPaint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    // for (var offset in offsets) {
    //   print("Offset: ${offset}");
    //   canvas.drawPoints(
    //       PointMode.points, offsets, paint);
    // }
    canvas.drawPoints(PointMode.polygon, positions, otherPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  
}

