import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/animations.dart';

class TemporaryPage {
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isVisible = ref.watch(isVisibleProvider);

    if (!isVisible) {
      Future.delayed(const Duration(milliseconds: 200), () {
        ref.read(isVisibleProvider.notifier).state = true;
      });
    }

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          bottom: isVisible ? (screenHeight / 2 - screenHeight * 0.12 / 2) : -screenHeight * 0.12,
          left: screenWidth * 0.15,
          right: screenWidth * 0.15,
          child: Container(
            color: Colors.amber,
            width: screenWidth * 0.7,
            height: screenHeight * 0.12,
          ),
        ),
      ],
    );
  }
}