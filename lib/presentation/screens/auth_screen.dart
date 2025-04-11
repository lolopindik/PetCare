import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/presentation/pages/auth_page.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: AuthPage().build(context));
  }
}
