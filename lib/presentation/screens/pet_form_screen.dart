import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/pet_form.dart';
import 'package:pet_care/presentation/pages/form_pages/initial_page.dart';
import 'package:pet_care/presentation/widgets/pet_form_apppbar.dart';

@RoutePage()
class PetFormScreen extends ConsumerWidget {
  const PetFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentStep = ref.read(stepProvider).step;
    final maxSteps = ref.read(stepProvider).maxSteps;

    final List<Widget> pages = [
      InitialPage().build(context, ref),
    ];

    return Scaffold(
      appBar: PetFormApppbar().build(context, currentStep, maxSteps),
      body: IndexedStack(
        index: currentStep,
        children: pages, 
      ),
    );
  }
}