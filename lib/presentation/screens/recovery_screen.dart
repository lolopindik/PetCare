import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/presentation/pages/recovery_page.dart';

@RoutePage()
class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RecoveryPage().build(context),
    );
  }
}