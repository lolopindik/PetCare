import 'package:flutter/material.dart';
import 'package:linear_progress_bar/titled_progress_bar.dart';
import 'package:pet_care/logic/riverpod/pet_form.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';

class PetFormApppbar {
  PreferredSizeWidget? build(BuildContext context, currentStep, maxSteps, ref) {
    final stepDecrement = ref.read(stepProvider).decrementStep;

    Map<int, String> label = {
      1: 'Tell us about your pet',
      2: 'Find breed of pet ',
      3: '333',
      4: '444'
    };

    return AppBar(
      leading: (currentStep > 1)
          ? IconButton(
              onPressed: () => stepDecrement(),
              icon: Icon(Icons.arrow_back_ios_new))
          : null,
      backgroundColor: const Color.fromARGB(255, 217, 217, 217),
      toolbarHeight: MediaQuery.of(context).size.height * 0.1,
      centerTitle: true,
      title: Column(
        children: <Widget>[
          Text(
            'Add pet profile',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Text(
            '${label[currentStep]}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color.fromARGB(255, 112, 112, 112),
                  fontWeight: FontWeight.bold,
                ),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            'Step $currentStep/$maxSteps',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 112, 112, 112),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: Container(
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 15),
          child: TitledProgressBar(
            maxSteps: maxSteps,
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
