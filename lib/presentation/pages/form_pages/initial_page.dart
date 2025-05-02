import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/riverpod/pet_form.dart';

class InitialPage {
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    final stepIncrement = ref.read(stepProvider).incrementStep;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: screenHeight * 0.6,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20)),
            ),
            Gap(60),
            ElevatedButton(
              //todo add logic to check if fields are filled
              onPressed: (){
                stepIncrement();
              },
              style: ButtonStyle(),
              child: Text('Continue'),
            ),
            // TextButton(
            //     onPressed: () {},
            //     child: Text(
            //       'Skip for now',
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodySmall
            //           ?.copyWith(fontSize: 12),
            //     )),
          ],
        ),
      ),
    );
  }
}
