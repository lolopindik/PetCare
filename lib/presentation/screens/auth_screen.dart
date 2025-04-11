import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/bottombar_index.dart';
import 'package:pet_care/presentation/screens/sign_in_screen.dart';
import 'package:pet_care/presentation/screens/sign_up_screen.dart';
import 'package:pet_care/presentation/widgets/auth_bottombar.dart';

@RoutePage()
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: BottomBarWidget().build(context, ref),
        body: IndexedStack(
        index: ref.watch(indexProvired).index,
        children: [
          SignUpScreen(),
          SignInScreen(),
        ],
      )
    );
  }
}
