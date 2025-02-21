import 'package:flutter/material.dart';
import '../Screens/home_screen.dart'; //todos los widgets de flutter

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'List Market',
      home: HomeScreen(),
    );
  }
}
