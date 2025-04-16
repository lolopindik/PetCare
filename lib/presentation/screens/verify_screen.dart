import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/presentation/pages/verify_page.dart';

@RoutePage()
class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VerifyPage().build(context),
    );
  }
}