import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';
import 'package:pet_care/logic/riverpod/pet_form.dart';
import 'package:pet_care/logic/services/firebase/pets_service.dart';
import 'package:pet_care/logic/services/firebase/user_service.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';
import 'package:firebase_database/firebase_database.dart';

class ThirdPage {
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(typeProvder).index;
    final gender = ref.watch(genderProvider).gender;
    final isDog = type == 0;
    final isCat = type == 1;
    final isFemale = gender == 1;
    final selectedDiseases = ref.watch(selectedDiseasesProvider);
    final selectedDiseasesNotifier =
        ref.read(selectedDiseasesProvider.notifier);
    final noneSelected = ref.watch(noneSelectedProvider);
    final noneSelectedNotifier = ref.read(noneSelectedProvider.notifier);

    final Map<String, String> mapDog = {
      "Arthritis": "Joint inflammation common in older dogs.",
      "Hip Dysplasia": "Genetic joint issue common in large breeds.",
      "Obesity": "Common due to overfeeding and lack of exercise.",
      "Heart Disease": "Often related to age or breed.",
      "Allergies": "Common issue with various triggers.",
    };

    final Map<String, String> mapCat = {
      "Kidney Disease": "Common in older cats.",
      "Diabetes": "Often linked to obesity.",
      "Hyperthyroidism": "Overproduction of thyroid hormone.",
      "Dental Disease": "Common issue affecting teeth and gums.",
      "Obesity": "Common due to overfeeding and lack of exercise.",
    };

    final Map<String, String> femaleConditions = {
      "Pregnancy": "Potential pregnancy, requires special care.",
      "Pyometra": "Uterine infection, common in unspayed females.",
    };

    final animalData = isDog
        ? mapDog
        : isCat
            ? mapCat
            : {};
    final availableConditions = {...animalData};
    if (isFemale) availableConditions.addAll(femaleConditions);

    return ref.watch(petDataProvider).when(
          data: (petData) {
            final age = petData?["age"] ?? 0;

            String ageCategory;
            if (age <= 1) {
              ageCategory = "Puppy/Kitten";
            } else if (age <= 7) {
              ageCategory = "Adult";
            } else {
              ageCategory = "Senior";
            }

            return Scaffold(
              body: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 600
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // ignore: deprecated_member_use
                        LightModeColors.primaryColor.withOpacity(0.1),
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "Select health issues for your $ageCategory ${isDog ? "Dog" : "Cat"}:",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: LightModeColors.primaryColor,
                                  ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  child: CheckboxListTile(
                                    title: Text(
                                      "None of the above",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    value: noneSelected,
                                    activeColor: LightModeColors.primaryColor,
                                    onChanged: (bool? value) {
                                      noneSelectedNotifier.state = value ?? false;
                                      if (value == true) {
                                        selectedDiseasesNotifier.state = {};
                                      }
                                    },
                                  ),
                                ),
                                const Divider(),
                                ...availableConditions.entries.map((entry) {
                                  final diseaseName = entry.key;
                                  final isSelected =
                                      selectedDiseases.contains(diseaseName);
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    child: CheckboxListTile(
                                      title: Text(
                                        diseaseName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      subtitle: Text(
                                        entry.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      value: isSelected,
                                      activeColor: LightModeColors.primaryColor,
                                      enabled: !noneSelected,
                                      onChanged: noneSelected
                                          ? null
                                          : (bool? selected) {
                                              if (selected == true) {
                                                selectedDiseasesNotifier.update(
                                                    (state) =>
                                                        {...state, diseaseName});
                                              } else {
                                                selectedDiseasesNotifier
                                                    .update((state) {
                                                  final updated =
                                                      Set<String>.from(state);
                                                  updated.remove(diseaseName);
                                                  return updated;
                                                });
                                              }
                                            },
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                        const Gap(24),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                final userId = await UserService.getUserUuid();
                                final petId = await PetsService()
                                    .getFirstPetId(userId.toString());
                                final dbRef =
                                    FirebaseDatabase.instance.ref("userDetails");
                                await dbRef
                                    .child("$userId/Pets/$petId/HealthConditions")
                                    .set({
                                  "conditions": noneSelected
                                      ? []
                                      : selectedDiseases.toList(),
                                  "hasNoConditions": noneSelected,
                                });
                                // ignore: use_build_context_synchronously
                                await dbRef.child(userId).update({'hasPetProfile': true});
                
                                // ignore: use_build_context_synchronously
                                Future.microtask(() => context.router.replacePath('/home'));
                
                                DebugLogger.print(
                                    'Health conditions saved successfully');
                              } catch (e) {
                                DebugLogger.print('Error saving conditions: $e');
                                rethrow;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: LightModeColors.gradientTeal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              "Save and Continue",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator(
              animating: true,
              radius: 15,
            ),),
          error: (error, stack) =>
              Center(child: Text("Failed to load pet data: $error")),
        );
  }
}
