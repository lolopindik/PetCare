// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';
import 'package:pet_care/logic/riverpod/textfield_handler.dart';
import 'package:pet_care/logic/services/firebase/authentication_service.dart';
import 'package:pet_care/logic/services/firebase/user_service.dart';
import 'package:pet_care/logic/services/google_auth_service.dart';
import 'package:pet_care/logic/services/snackbar_service.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';
import 'package:pet_care/presentation/widgets/auth_google.dart';
import 'package:pet_care/presentation/widgets/custom_textfield.dart';

class SignInPage {
  Widget build(BuildContext context, WidgetRef ref) {

    final controllerEmail = ref.watch(textFieldControllerProvider('signInEmail'));
    final controllerPassword = ref.watch(textFieldControllerProvider('signInPassword'));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(MediaQuery.of(context).size.height * 0.2),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              LightModeColors.primaryColor,
                              LightModeColors.gradientTeal,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Login',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Gap(20),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  CustomTextfieldWidget().build(
                                    context,
                                    'Email',
                                    ref,
                                    'signInEmail',
                                    false,
                                  ),
                                  const Gap(16),
                                  CustomTextfieldWidget().build(
                                    context,
                                    'Password',
                                    ref,
                                    'signInPassword',
                                    true,
                                  ),
                                  const Gap(24),
                                  ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await EmailSignInService().signIn(
                                          emailAddress: controllerEmail.text.trim(),
                                          password: controllerPassword.text.trim(),
                                        );

                                        final user = await UserService.getUser();

                                        if (user != null) {
                                          SnackbarServices.showSuccessSnackbar(
                                              context, 'Success sign in');
                                          context.router.replacePath('/home');
                                          DebugLogger.print('\x1B[32mSuccess sign in');
                                        }
                                      } catch (e) {
                                        SnackbarServices.showErrorSnackbar(context, 'Error: $e');
                                        DebugLogger.print(
                                            '\x1B[31m(error) On sign in screen: $e');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: LightModeColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(30),
                  AuthGoogleWidget().build(
                    context,
                    () async {
                      final user = await GoogleAuthService().signInWithGoogle();
                      if (user != null) {
                        SnackbarServices.showSuccessSnackbar(context, 'Signed in with Google');
                        context.router.replacePath('/home');
                      } else {
                        SnackbarServices.showErrorSnackbar(context, 'Google Sign-In failed');
                      }
                    },
                      'Sign in with Google'
                  ),
                  const Gap(80),
                  TextButton(
                    onPressed: () => context.router.pushPath('/auth/recovery'),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}