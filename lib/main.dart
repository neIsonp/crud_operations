import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_study/pages/home_page.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
