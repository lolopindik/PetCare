import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';
import 'package:pet_care/presentation/widgets/auth_google.dart';
import 'package:pet_care/presentation/widgets/auth_textfield.dart';

class SignUpPage {
  Widget build(BuildContext context, WidgetRef ref) {
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
                  Gap(MediaQuery.of(context).size.height * 0.1),
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
                              'Sign Up',
                              style:
                                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                            const Gap(20),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface, // White or dark grey
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  AuthTextfieldWidget().build(
                                    context,
                                    'Username',
                                    ref,
                                    'signUpUsername',
                                    false,
                                  ),
                                  const Gap(16),
                                  AuthTextfieldWidget().build(
                                    context,
                                    'Email',
                                    ref,
                                    'signUpEmail',
                                    false,
                                  ),
                                  const Gap(16),
                                  AuthTextfieldWidget().build(
                                    context,
                                    'Password',
                                    ref,
                                    'signUpPassword',
                                    true,
                                  ),
                                  const Gap(16),
                                  AuthTextfieldWidget().build(
                                    context,
                                    'Confirm Password',
                                    ref,
                                    'signUpConfirmPassword',
                                    true,
                                  ),
                                  const Gap(24),
                                  ElevatedButton(
                                    onPressed: () {
                                      //todo add other logic
                                      context.router.pushPath('/auth/verification');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          LightModeColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                          fontSize: 16, fontFamily: 'Poppins'),
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
                  AuthGoogleWidget().build(context, () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
