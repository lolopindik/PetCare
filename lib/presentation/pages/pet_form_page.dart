import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';

class PetFormPage {
  Widget build(BuildContext context, WidgetRef ref) {

    // final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressBar(
              maxSteps: 4,
              progressType:
                  LinearProgressBar.progressTypeLinear,
              currentStep: 1,
              progressColor: LightModeColors.secondaryColor,
              backgroundColor: LightModeColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }
}
