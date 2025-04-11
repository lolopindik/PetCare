import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pet_care/logic/riverpod/intro.dart';

class WelcomePage {
  
  static const List<Map<String, dynamic>> _pagesData = [
    {
      'titlePath': 'lib/logic/src/assets/imgs/welcome.png',
      'bodyPath': 'lib/logic/src/assets/icons/icon_dog&cat.png',
      'titlePadding': 0.1,
      'bodyPadding': 0.05,
    },
    {
      'titlePath': 'lib/logic/src/assets/icons/icon_title_1.png',
      'bodyPath': 'lib/logic/src/assets/icons/icon_pet_a_pet.png',
      'titlePadding': 0.15,
      'bodyPadding': 0.11,
    },
    {
      'titlePath': 'lib/logic/src/assets/icons/icon_title_2.png',
      'bodyPath': 'lib/logic/src/assets/icons/icon_documents.png',
      'titlePadding': 0.15,
      'bodyPadding': 0.075,
    },
    {
      'titlePath': 'lib/logic/src/assets/icons/icon_title_3.png',
      'bodyPath': 'lib/logic/src/assets/icons/icon_form.png',
      'titlePadding': 0.2,
      'bodyPadding': 0.14,
    },
  ];

  Widget _buildImageWidget(BuildContext context, String path, double paddingFraction) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * paddingFraction),
      child: Center(
        child: Image.asset(path),
      ),
    );
  }

  Widget build(BuildContext context, WidgetRef ref) {

    return IntroductionScreen(
      pages: _pagesData.map((data) {
        return PageViewModel(
          titleWidget: _buildImageWidget(
            context,
            data['titlePath'] as String,
            data['titlePadding'] as double,
          ),
          bodyWidget: _buildImageWidget(
            context,
            data['bodyPath'] as String,
            data['bodyPadding'] as double,
          ),
        );
      }).toList(),
      onDone: () {
        ref.read(introProvider).markIntroAsSeen();
        context.router.replacePath('/auth');
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Сontinue", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}