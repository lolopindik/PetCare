// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';
import 'package:pet_care/logic/riverpod/textfield_handler.dart';
import 'package:pet_care/logic/services/firebase/authentication_service.dart';
import 'package:pet_care/logic/services/snackbar_service.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';
import 'package:pet_care/presentation/widgets/custom_textfield.dart';

class RecoveryPage {
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerEmail = ref.watch(textFieldControllerProvider('recoveryEmail'));

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
                              'Recover Password',
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
                                    'recoveryEmail',
                                    false,
                                  ),
                                  const Gap(24),
                                  ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        final email = controllerEmail.text.trim();
                                        PasswordReset().resetPassword(email);

                                        SnackbarServices.showSuccessSnackbar(
                                          context,
                                          'Password reset email sent successfully!',
                                        );
                                        DebugLogger.print('\x1B[32mPassword reset email sent');
                                      } catch (e) {
                                        SnackbarServices.showErrorSnackbar(
                                          context,
                                          'Error: $e',
                                        );
                                        DebugLogger.print(
                                          '\x1B[31m(error) On recovery page: $e',
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: LightModeColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Send Reset Link',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}