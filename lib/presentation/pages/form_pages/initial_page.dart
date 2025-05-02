import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/riverpod/pet_form.dart';

class InitialPage {
  Widget build(BuildContext context, WidgetRef ref) {

    final stepIncrement = ref.read(stepProvider).incrementStep;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 1, 
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  )
                ),
                )),
              Expanded(flex: 7,
               child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    bottomLeft:Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  )
                ),
                )),
              Gap(60),
              ElevatedButton(
                //todo add logic to check if fields are filled
                onPressed: () {
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
      ),
    );
  }
}
