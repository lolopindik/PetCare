// ignore_for_file: use_build_context_synchronously, unused_import

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/connectivity.dart';
import 'package:pet_care/logic/riverpod/intro.dart';
import 'package:pet_care/logic/riverpod/verification.dart';
import 'package:pet_care/logic/services/snackbar_service.dart';
import 'package:pet_care/presentation/routes/router.gr.dart';

class SplashPage {
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() async {
      final connectivity = ref.watch(connectivityProvider);
      final hasInternet = connectivity != ConnectivityResult.none;
      final verifiedNotifier = ref.read(verifiedProvider.notifier);
      final hasverified = await verifiedNotifier.hasVerified;
      final user = FirebaseAuth.instance.currentUser;

      if (!hasInternet) {
        // SnackbarServices.showErrorSnackbar(context, 'No internet connection');
        return;
      }

      final hasSeenIntro = await ref.read(introProvider).hasSeenIntro;

      if (!hasSeenIntro && user == null) {
        context.router.replace(const WelcomeRoute());
      } else if (user != null && hasverified == true) {
        context.router.replace(const HomeRoute());
      } else if (user != null && hasverified == false) {
        context.router.replace(const VerifyRoute());
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
