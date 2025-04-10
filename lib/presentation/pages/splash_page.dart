// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/connectivity.dart';
import 'package:pet_care/logic/riverpod/intro.dart';
import 'package:pet_care/presentation/routes/router.gr.dart';

class SplashPage {
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() async {
      final connectivity = ref.watch(connectivityProvider);
      final hasInternet = connectivity != ConnectivityResult.none;

      if (!hasInternet) {
        //* can add snackbar
        return;
      }

      final hasSeenIntro = await ref.read(introProvider).hasSeenIntro;

      if (!hasSeenIntro) {
        context.router.replace(const WelcomeRoute());
      } else {
        context.router.replace(const AuthRoute());
      }
    });

    return Stack(
      children: [
        Center(
          child: Image.asset(
            'lib/logic/src/assets/imgs/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: CupertinoActivityIndicator(
              animating: true,
              radius: 15,
            ),
          ),
        ),
      ],
    );
  }
}