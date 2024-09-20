import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
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
  void updateVals(UserAccelerometerEvent event){
    dateTime = DateTime.now();
    deltaT = (dateTime.millisecondsSinceEpoch - time).toDouble()/1000; //Change in time in seconds
    if(deltaT > 0.01){
      xAccel = num.parse(event.x.toStringAsFixed(1)).toDouble();
      yAccel = num.parse(event.y.toStringAsFixed(1)).toDouble();
      zAccel = num.parse(event.z.toStringAsFixed(1)).toDouble();
      print("$xAccel, $yAccel, $zAccel");
      //if(magnitude(xAccel, yAccel, zAccel) > 0.01){
      double initX = velX;
      double initY = velY;
      double initZ = velZ;
      velX = (xAccel*deltaT) + initX;
      velY = (yAccel*deltaT) + initY;
      velZ = (zAccel*deltaT) + initZ;
      xPos = xPos + ((initX+velX)/2)*deltaT;
      yPos = yPos + ((initY+velY)/2)*deltaT;
      zPos = zPos + ((initY+velZ)/2)*deltaT;
      print("$xPos, $yPos, $zPos");
      time = dateTime.millisecondsSinceEpoch;
      //}
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