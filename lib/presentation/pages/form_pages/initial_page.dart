import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/data/model/pet_form_model.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';
import 'package:pet_care/logic/riverpod/pet_form.dart';
import 'package:pet_care/logic/riverpod/textfield_handler.dart';
import 'package:pet_care/logic/services/firebase/form_service.dart';
import 'package:pet_care/logic/services/firebase/pets_service.dart';
import 'package:pet_care/logic/services/firebase/user_service.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';
import 'package:pet_care/presentation/widgets/custom_textfield.dart';

class InitialPage {
  Widget build(BuildContext context, WidgetRef ref) {
    final stepIncrement = ref.read(stepProvider).incrementStep;
    final type = ref.watch(typeProvder);
    final gender = ref.watch(genderProvider);

    final controllerName = ref.watch(textFieldControllerProvider('petName'));
    final controllerAge = ref.watch(textFieldControllerProvider('petAge'));
    final controllerWeight =
        ref.watch(textFieldControllerProvider('petWeight'));

    final screenWidth = MediaQuery.of(context).size.width;

    final List<Map<String, String>> petType = [
      {'image': 'lib/logic/src/assets/icons/icon-dog.png', 'label': 'Dog'},
      {'image': 'lib/logic/src/assets/icons/icon-cat.png', 'label': 'Cat'}
    ];

    final List<String> petGender = ['Male', 'Female'];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: screenWidth,
                  height: MediaQuery.of(context).size.height * 0.09,
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
                  padding: const EdgeInsets.all(16),
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
                        isNumeric: true,
                      ),
                      const Gap(12),
                      CustomTextfieldWidget().build(
                        context,
                        'Pet weight in kg',
                        ref,
                        'petWeight',
                        false,
                        isNumeric: true,
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int index = 0;
                              index < petGender.length;
                              index++) ...[
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ElevatedButton(
                                onPressed: () {
                                  gender.genderTogle(index);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (gender.gender == index)
                                      ? LightModeColors.primaryColor
                                      : Color(0xFFE0E0E0),
                                  foregroundColor: (gender.gender == index)
                                      ? Colors.white
                                      : Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  petGender[index],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                      const Gap(20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Type of your pet:',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                  ),
                        ),
                      ),
                      const Gap(20),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: petType.map((pet) {
                            final index = petType.indexOf(pet);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(60),
                                    onTap: () {
                                      type.togleType(index);
                                    },
                                    child: Container(
                                      height: (type.index == index) ? 110 : 100,
                                      width: (type.index == index) ? 110 : 100,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: (type.index == index)
                                                ? LightModeColors.primaryColor
                                                : Colors.transparent,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(
                                                0, 0), // Adjust as needed
                                          ),
                                        ],
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(60),
                                        image: DecorationImage(
                                          image: AssetImage(pet['image']!),
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(
                                    pet['label']!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(80),
                ElevatedButton(
                  onPressed: (gender.gender > -1 &&
                          type.index > -1 &&
                          controllerName.text.trim().isNotEmpty &&
                          controllerWeight.text.trim().isNotEmpty)
                      ? () async {
                          try {
                            FirstPageModel pet = FirstPageModel.initialize(
                                petAge:
                                    int.tryParse(controllerAge.text.trim()) ??
                                        0,
                                petGender: gender.gender,
                                petName: controllerName.text.trim(),
                                petType: type.index,
                                petWeight: double.tryParse(
                                        controllerWeight.text.trim()) ??
                                    0.0);

                            final data = pet.toMap();

                            final userId = await UserService.getUserUuid();
                            final petService = PetsService();

                            DebugLogger.print(data.toString());
                            // ignore: unnecessary_null_comparison
                            if(petService.getFirstPetId(userId) != null) {
                              await petService.deleteFirstPetId(userId);
                            }
                            await SaveFirstPage().saveForm(data);
                            stepIncrement();
                          } catch (e) {
                            DebugLogger.print('$e');
                            rethrow;
                          }
                        }
                      : null,
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
                    // style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
