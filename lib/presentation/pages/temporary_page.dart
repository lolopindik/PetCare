import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/animations.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';

class TemporaryPage {
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isVisible = ref.watch(isVisibleProvider);

    if (!isVisible) {
      Future.delayed(const Duration(milliseconds: 100), () {
        ref.read(isVisibleProvider.notifier).state = true;
      });
    }

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          bottom: isVisible
              ? (screenHeight / 2 - screenHeight * 0.1 / 2)
              : -screenHeight * 0.1,
          left: screenWidth * 0.1,
          right: screenWidth * 0.1,
          child: AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeIn,
            child: AnimatedScale(
              scale: isVisible ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              child: GestureDetector(
                onTap: () {
                  context.router.replacePath('/form_for_pet');
                },
                child: Transform.rotate(
                  angle: isVisible ? -0.03 : -0.06,
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.1,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          LightModeColors.primaryColor,
                          LightModeColors.gradientTeal,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 12,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          right: 30,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        // Foreground content
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 14),
                            // Circle placeholder for future image
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 6,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.pets,
                                  color: Color(0xFF2A9D8F),
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Text
                            Text(
                              'Add Pet Profile',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
