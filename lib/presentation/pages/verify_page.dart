import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/riverpod/delete_data.dart';
import 'package:pet_care/logic/riverpod/email.dart';

class VerifyPage {
  Widget build(BuildContext context, WidgetRef ref) {

    final user = FirebaseAuth.instance.currentUser;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final email = ref.watch(emailProvider).email ?? "Loding...";

    return SafeArea(
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
                  email.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(24),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.setLanguageCode("en");
                  await user?.sendEmailVerification();
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
                  ref
                      .read(userDeletionProvider.notifier)
                      .deleteUserDataImmediately(userId!);
                      context.router.replacePath('/auth');
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
    );
  }
}
