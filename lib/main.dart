import 'package:flutter/material.dart';
import 'package:flutter_app_tienda_videos/inicio.dart';
void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Inicio()
    );
  }
}