import 'package:flutter/material.dart';

class NewScreen1 extends StatelessWidget {
  String payload;

  NewScreen1({required this.payload,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
      body: Center(child: Text("Welcome to notification Screen 1")),
    );
  }
}


class NewScreen2 extends StatelessWidget {
  String payload;

  NewScreen2({required this.payload,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
      body: Center(child: Text("Welcome to notification Screen 2")),
    );
  }
}

