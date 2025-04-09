import 'package:flutter/cupertino.dart';

class SplashPage {
  Widget build(BuildContext context){
    return  Stack(
        children: [
          Center(
            child: Image.asset(
              'lib/logic/assets/imgs/logo.png',
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: const CupertinoActivityIndicator(
                animating: true,
                radius: 15,
              ),
            ),
          ),
        ],
      );
  }
}