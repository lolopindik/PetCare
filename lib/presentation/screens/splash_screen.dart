import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:pet_care/presentation/pages/splash_page.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SplashPage().build(context)
    );
  }
}