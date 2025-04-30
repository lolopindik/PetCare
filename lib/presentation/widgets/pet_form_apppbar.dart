import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';

class PetFormApppbar {
  PreferredSizeWidget? build(BuildContext context, currentStep, maxSteps){
    return AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 217, 217),
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        centerTitle: true,
        title: Column(children: <Widget>[
          Text('Add pet profile', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22
          ),),
          Text('data from riverpod', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color.fromARGB(255, 112, 112, 112),
            fontWeight: FontWeight.bold,
          ),)
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text('Step $currentStep/$maxSteps', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 14,
              color: const Color.fromARGB(255, 112, 112, 112),
              fontWeight: FontWeight.bold,
            ),),
        ),
      ],
       bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 15),
            child: LinearProgressBar(
              maxSteps: maxSteps,
              progressType: LinearProgressBar.progressTypeLinear,
              currentStep: currentStep,
              progressColor: LightModeColors.secondaryColor,
              backgroundColor: LightModeColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
  }
}