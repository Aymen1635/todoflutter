import 'package:flutter/material.dart';
import 'package:todo_flutter/ui/splash/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
