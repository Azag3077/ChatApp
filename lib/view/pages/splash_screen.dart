import 'package:flutter/material.dart';

import '../controllers/controller.dart';
import '../controllers/splash_screen.dart';

class SplashScreen extends StatefulWidget with SplashScreenController {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    widget.initialize(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
