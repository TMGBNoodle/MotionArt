import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Sensordata {
  Sensordata(){
    init();
  }
  DateTime dateTime = DateTime.now();
  final Duration samplePeriod = const Duration(milliseconds: 1);
  final int multiplier = 50;
  final double minX = -3;
  final double minY = -9;
  final double maxX = 3;
  final double maxY = 3;
  //List<double> times = [0];
  List<double> xAccels = [0, 0];
  List<double> yAccels = [0, 0];
  List<double> zAccels = [0, 0]; 
  List<double> xVels = [0, 0];
  List<double> yVels = [0, 0];
  List<double> zVels = [0, 0];
  List<double> xPositions = [0, 0];
  List<double> yPositions = [0, 0];
  List<double> zPositions = [0, 0];
  final int interval = 16;
  double zeroX = 0;
  double zeroY = 0;
  double zeroZ = 0;
  bool zeroFlag = true;
  int time = 0;
  int count = 0;
  int xZeroCount = 0;
  int yZeroCount = 0;
  int zZeroCount = 0;
  double deltaT = 0;
  UserAccelerometerEvent? acceleration;
  final stream = <StreamSubscription<UserAccelerometerEvent>>[];

  void updateVals(UserAccelerometerEvent event){
    dateTime = DateTime.now();
    deltaT = (dateTime.millisecondsSinceEpoch - time).toDouble()/1000; //Change in time in seconds
    if(zeroFlag == true){
      zeroX += event.x;
      zeroY += event.y;
      zeroZ += event.z;
      count += 1;
      if(count >= 1024){
        zeroX = zeroX/count;
        zeroY = zeroY/count;
        zeroZ = zeroZ/count;
        zeroFlag = false;
        count = 0;
      }
    }
    else {
      xAccels[1] = xAccels[1] + event.x - zeroX;
      yAccels[1] = yAccels[1] + event.y - zeroY;
      zAccels[1] = zAccels[1] + event.z - zeroZ;
      count += 1;
      if(count >= interval) {
        xAccels[1] = xAccels[1]/count;
        yAccels[1] = yAccels[1]/count;
        zAccels[1] = zAccels[1]/count;
        count = 0;
        if(xAccels[1].abs() <= 0.05){
          xAccels[1] = 0.0;
          xZeroCount+=1;
        }
        else {xZeroCount = 0;}
        if(yAccels[1].abs() <= 0.05){
          yAccels[1] = 0.0;
          yZeroCount+=1;
        } else {yZeroCount = 0;}
        if(zAccels[1].abs() <= 0.05){
          zAccels[1] = 0.0;
          zZeroCount+=1;
        } else {zZeroCount = 0;}
        if(xZeroCount>=2){
          xVels[1] = 0;
        } else{
          xVels[1] = xVels[0] + xAccels[0] + ((xAccels[1]-xAccels[0])/2) * deltaT;
        }
        if(yZeroCount>=2){
          yVels[1] = 0;
        } else {
          yVels[1] = yVels[0] + yAccels[0] + ((yAccels[1]-yAccels[0])/2) * deltaT;
        }
        if(zZeroCount>=2){
          zVels[1] = 0;
        } else {
          zVels[1] = zVels[0] + zAccels[0] + ((zAccels[1]-zAccels[0])/2) * deltaT;
        }
        xPositions[1] = min(maxX, max((xPositions[0] + xVels[0] + ((xVels[1] - xVels[0])/2) * deltaT),minX));
        yPositions[1] = min(maxY, max((yPositions[0] + yVels[0] + ((yVels[1] - yVels[0])/2) * deltaT),minY));
        zPositions[1] = zPositions[0] + zVels[0] + ((zVels[1] - zVels[0])/2) * deltaT;

        xAccels[0] = xAccels[1];
        yAccels[0] = yAccels[1];
        zAccels[0] = zAccels[1];
        xAccels[1] = 0;
        yAccels[1] = 0;
        zAccels[1] = 0;

        xVels[0] = xVels[1];
        yVels[0] = yVels[1];
        zVels[0] = zVels[1];

        xPositions[0] = xPositions[1];
        yPositions[0] = yPositions[1];
        zPositions[0] = zPositions[1];
        dateTime = DateTime.now();
        time = dateTime.millisecondsSinceEpoch;
      }
    }
  }
  void init() { 
    time = dateTime.millisecondsSinceEpoch;
    stream.add(userAccelerometerEventStream(samplingPeriod: samplePeriod).listen(updateVals));
  }
  List<double> grabXYZ(){
    return [xPositions.last * multiplier, yPositions.last * multiplier, zPositions.last * multiplier];
  }
  void reInit(){
    xPositions = [0,0];
    yPositions = [0,0];
    zPositions = [0,0];
    xVels = [0,0];
    yVels = [0,0];
    zVels = [0,0];
  }
}