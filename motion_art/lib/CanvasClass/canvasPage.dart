import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class CanvasPage {
  final String title;
  final String image;
  final String description;
  final double x;
  final double y;
  final List<Pixel> pixels = [];
  final Color color = Colors.black;
  CanvasPage({required this.title, required this.image, required this.description, required this.x, required this.y});


  coordinatesToPixels(List<List<int>> coordinates) {
    for (var i = 0; i < coordinates.length; i++) {
      Pixel p = Pixel(x: coordinates[i][0], y: coordinates[i][1], color: this.color);
      pixels.add(p);
    }
  }


  void drawPixel(int x, int y, Color color) {
    new Pixel(x: x, y: y, color: this.color);
    // Draw a pixel at x, y with color
  }

  void drawPixels(List<Pixel> pixels) {
    // Draw a list of pixels
    for (var i = 0; i < pixels.length; i++) {
      drawPixel(pixels[i].x, pixels[i].y, pixels[i].color);
    }
  }
}

class Pixel {
  final int x;
  final int y;
  final Color color;
  Pixel({required this.x, required this.y, required this.color});
}