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
  Duration samplePeriod = const Duration(milliseconds: 10);
  List<double> times = [0];
  List<double> xAccels = [0, 0];
  List<double> yAccels = [0, 0];
  List<double> zAccels = [0, 0]; 
  List<double> xVels = [0, 0];
  List<double> yVels = [0, 0];
  List<double> zVels = [0, 0];
  List<double> xPositions = [0, 0];
  List<double> yPositions = [0, 0];
  List<double> zPositions = [0, 0];
  final int interval = 128;
  double xAccel = 0;
  double yAccel = 0;
  double zAccel = 0;
  double velX = 0;
  double velY = 0;
  double velZ = 0;
  double xPos = 0;
  double yPos = 0;
  double zPos = 0;
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
  
  double roundNumTo(x, decimal){
    return num.parse(x.toStringAsFixed(decimal)).toDouble();
  }

  double magnitude(x, y, z){
    return sqrt((x^2+y^2+z^2));
  }
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
        print("Elsa $zeroX");
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
        print("Sampling finished, ${xAccels[1]}");
        if(xAccels[1].abs() <= 0.01){
          xAccels[1] = 0.0;
          xZeroCount+=1;
        } else {xZeroCount = 0;}
        if(yAccels[1].abs() <= 0.01){
          yAccels[1] = 0.0;
          yZeroCount+=1;
        } else {yZeroCount = 0;}
        if(zAccels[1].abs() <= 0.01){
          zAccels[1] = 0.0;
          zZeroCount+=1;
        } else {zZeroCount = 0;}
        if(xZeroCount>=5){
          xVels[1] = 0;
        } else{
          xVels[1] = xVels[0] + xAccels[0] + ((xAccels[1]-xAccels[0])/2) * deltaT;
        }
        if(yZeroCount>=5){
          yVels[1] = 0;
        } else {
          yVels[1] = yVels[0] + yAccels[0] + ((yAccels[1]-yAccels[0])/2) * deltaT;
        }
        if(zZeroCount>=5){
          zVels[1] = 0;
        } else {
          zVels[1] = zVels[0] + zAccels[0] + ((zAccels[1]-zAccels[0])/2) * deltaT;
        }
        xPositions[1] = xPositions[0] + xVels[0] + ((xVels[1] - xVels[0])/2) * deltaT;
        yPositions[1] = yPositions[0] + yVels[0] + ((yVels[1] - yVels[0])/2) * deltaT;
        zPositions[1] = zPositions[0] + zVels[0] + ((zVels[1] - zVels[0])/2) * deltaT;

        xAccels[0] = xAccels[1];
        yAccels[0] = yAccels[1];
        zAccels[0] = zAccels[1];

        xVels[0] = xVels[1];
        yVels[0] = yVels[1];
        zVels[0] = zVels[1];

        xPositions[0] = xPositions[1];
        yPositions[0] = yPositions[1];
        zPositions[0] = zPositions[1];
      }
    }
    // deltaT = (dateTime.millisecondsSinceEpoch - time).toDouble()/1000; //Change in time in seconds
    // times.add(deltaT);
    // xAccels.add(event.x-zeroX);
    // yAccels.add(event.y-zeroY);
    // zAccels.add(event.z-zeroZ);
    // if(xAccels.length > 2){
    //   xAccels.removeAt(0);
    //   yAccels.removeAt(0);
    //   zAccels.removeAt(0);
    // }
    // print("Accel: $xAccel, $yAccel, $zAccel");
    // velX = roundNumTo(((xAccel*deltaT + velX)),0);
    // velY = roundNumTo(((yAccel*deltaT + velY)),0);
    // velZ = roundNumTo(((zAccel*deltaT + velZ)),0);
    // print("Velocity: $velX, $velY, $velZ");
    // xPos = roundNumTo((xPos + ((velX)/2)*deltaT), 2);
    // yPos = roundNumTo((yPos + ((velY)/2)*deltaT), 2);
    // zPos = roundNumTo((zPos + ((velZ)/2)*deltaT), 2);
    // print("${event.x}, ${event.y}, ${event.z}");
    // print("Accels: ${xAccels}, ${yAccels}, ${zAccels}");
    // print("Vels: ${xVels}, ${yVels}, ${zVels}");
    // print("Positions: ${xPositions}, ${yPositions}, ${zPositions}");
    // print("Pos: ${xPositions.last}, ${yPositions.last}, ${zPositions.last}");
    // time = dateTime.millisecondsSinceEpoch;
  }
  void init() { 
    time = dateTime.millisecondsSinceEpoch;
    stream.add(userAccelerometerEventStream(samplingPeriod: samplePeriod).listen(updateVals));
  }
  List<double> grabXYZ(){
    return [xPositions.last, yPositions.last, zPositions.last];
  }
  void reInit(){
    xPos = 0;
    yPos = 0;
    zPos = 0;
  }
}