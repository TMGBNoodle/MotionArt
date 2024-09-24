import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class Sensordata {
  Sensordata(){
    init();
  }
  DateTime dateTime = DateTime.now();
  double xAccel = 0;
  double yAccel = 0;
  double zAccel = 0;
  double velX = 0;
  double velY = 0;
  double velZ = 0;
  double xPos = 0;
  double yPos = 0;
  double zPos = 0;
  int time = 0;
  double deltaT = 0;
  UserAccelerometerEvent? acceleration;
  final stream = <StreamSubscription<UserAccelerometerEvent>>[];
  double magnitude(x, y, z){
    return sqrt((x^2+y^2+z^2));
  }
  double roundNumTo(x, decimal){
    return num.parse(x.toStringAsFixed(decimal)).toDouble();
  }
  void updateVals(UserAccelerometerEvent event){
    dateTime = DateTime.now();
    deltaT = (dateTime.millisecondsSinceEpoch - time).toDouble()/1000; //Change in time in seconds
    if(deltaT > 0.2)
    {
      print("Raw Accel: ${event.x-(-0.005)}, ${event.y- (-0.002)}, ${event.z - (0.003)}");
      xAccel = num.parse((event.x-(-0.005)).toStringAsFixed(2)).toDouble();
      yAccel = num.parse((event.y- (-0.002)).toStringAsFixed(2)).toDouble();
      zAccel = num.parse((event.z - (0.003)).toStringAsFixed(2)).toDouble();
      print("Accel: $xAccel, $yAccel, $zAccel");
      velX = roundNumTo(((xAccel*deltaT + velX)),0);
      velY = roundNumTo(((yAccel*deltaT + velY)),0);
      velZ = roundNumTo(((zAccel*deltaT + velZ)),0);
      print("Velocity: $velX, $velY, $velZ");
      xPos = roundNumTo((xPos + ((velX)/2)*deltaT), 2);
      yPos = roundNumTo((yPos + ((velY)/2)*deltaT), 2);
      zPos = roundNumTo((zPos + ((velZ)/2)*deltaT), 2);
      print("Pos: $xPos, $yPos, $zPos");
      time = dateTime.millisecondsSinceEpoch;
    }
  }
  void init() { 
    time = dateTime.millisecondsSinceEpoch;
    stream.add(userAccelerometerEventStream().listen(updateVals));
  }
  List<double> grabXYZ(){
    return [xAccel, yAccel, zAccel];
  }
  void reInit(){
    xPos = 0;
    yPos = 0;
    zPos = 0;
  }
}