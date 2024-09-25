

import 'package:flutter/material.dart';

class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MotionArt")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, "DrawPage");  // Navigate to second screen
          },
          child: const Text("Click to Begin"),
        ),
      ),
    );
  }
}
