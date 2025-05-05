import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/riverpod/pet_form.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';
import 'package:pet_care/presentation/widgets/custom_textfield.dart';

class InitialPage {
  Widget build(BuildContext context, WidgetRef ref) {
    final stepIncrement = ref.read(stepProvider).incrementStep;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: <Widget>[
              Container(
                width: screenWidth,
                height: screenHeight * 0.08,
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border.all(
                    width: 5,
                    color: Theme.of(context).primaryColor,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    "Enter Your Pet's Information",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                height: screenHeight * 0.5,
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(
                    width: 10,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                padding: const EdgeInsets.all(16), // Внутренний отступ
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextfieldWidget().build(
                      context,
                      'Pet name',
                      ref,
                      'petName',
                      false,
                    ),
                    const Gap(12),
                    CustomTextfieldWidget().build(
                      context,
                      'Pet age',
                      ref,
                      'petAge',
                      false,
                    ),
                    const Gap(12),
                    CustomTextfieldWidget().build(
                      context,
                      'Pet weight',
                      ref,
                      'petWeight',
                      false,
                    ),
                    const Gap(72),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          'Type of your pet:',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                  ),
                        ),
                      ),
                    ),
                    Gap(20),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(right: 15),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(80),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Gap(100),
              ElevatedButton(
                onPressed: () {
                  stepIncrement();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightModeColors.gradientTeal,
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
                  'Continue',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
