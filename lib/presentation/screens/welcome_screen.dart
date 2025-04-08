import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/presentation/pages/welcome_page.dart';

@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomePage().build(context),
    );
  }
}