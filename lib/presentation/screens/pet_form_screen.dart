import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/presentation/pages/pet_form_page.dart';

@RoutePage()
class PetFormScreen extends ConsumerWidget {
  const PetFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        centerTitle: true,
        title: Column(children: <Widget>[
          Text('Add pet profile', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color.fromARGB(255, 85, 85, 85),
            fontSize: 22
          ),),
          Text('data from riverpod', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey
          ),)
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text('Step 1/4', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 14,
              color: const Color.fromARGB(255, 85, 85, 85),
            ),),
        )
      ],
      ),
      body: PetFormPage().build(context, ref),
    );
  }
}