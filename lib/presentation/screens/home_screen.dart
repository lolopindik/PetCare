import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/presentation/pages/home_page.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: HomePage().build(context),
    );
  }
}