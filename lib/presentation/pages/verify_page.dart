// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/riverpod/delete_data.dart';
import 'package:pet_care/logic/riverpod/email.dart';
import 'package:pet_care/logic/riverpod/verification.dart';
import 'package:pet_care/logic/services/firebase/user_service.dart';
import 'package:pet_care/logic/services/snackbar_service.dart';
import 'package:pet_care/presentation/routes/router.gr.dart';

class VerifyPage {
  Widget build(BuildContext context, WidgetRef ref) {
    final user = UserService.getUser();
    // final userId = await UserService.getUserUuid();
    final email = ref.watch(emailProvider).email ?? "Loading...";
    final verifiedNotifier = ref.read(verifiedProvider.notifier);

    Timer? verificationTimer;

    void checkInitialState() async {
      if (user == null) {
        verificationTimer?.cancel();
        SnackbarServices.showErrorSnackbar(context, 'No user signed in');
        context.router.replace(const AuthRoute());
        return;
      }
      final isVerified = await verifiedNotifier.hasVerified;
      if (isVerified) {
        verificationTimer?.cancel();
        context.router.replacePath('/home');
      }
    }

    void startVerificationCheck() {
      verificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        final isVerified = await verifiedNotifier.hasVerified;
        if (isVerified) {
          timer.cancel();
          context.router.replacePath('/home');
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInitialState();
      startVerificationCheck();
    });

    void dispose() {
      verificationTimer?.cancel();
    }

    return SafeArea(
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pets,
                  size: 80,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                const Gap(24),
                Text(
                  "Verify Your Email",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(16),
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(24),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await verifiedNotifier.sendEmailVerificationLink();
                      SnackbarServices.showSuccessSnackbar(
                          context, 'Verification email sent');
                    } catch (e) {
                      SnackbarServices.showErrorSnackbar(
                          context, e.toString().replaceFirst('Exception: ', ''));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Send Verification",
                    style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                  ),
                ),
                const Gap(16),
                TextButton(
                  onPressed: () async {

                    final userId = await UserService.getUserUuid();

                    if (userId != null) {
                      await ref
                          .read(userDeletionProvider.notifier)
                          .deleteUserDataImmediately(userId);
                    }
                    dispose(); // Clean up timer
                    context.router.replace(const AuthRoute());
                  },
                  child: Text(
                    "Back to Login",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}