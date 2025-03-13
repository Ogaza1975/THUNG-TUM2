import 'package:flutter/material.dart';

class Picturematch extends StatefulWidget {
  @override
  _PicturematchState createState() => _PicturematchState();
}

class _PicturematchState extends State<Picturematch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picturematch'),
      ),
      body: Center(
        child: Text('Picturematch'),
      ),
    );
  }
}
