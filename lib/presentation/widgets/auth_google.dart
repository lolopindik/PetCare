import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AuthGoogleWidget {
  Widget build(BuildContext context, VoidCallback func) {
    return GestureDetector(
      onTap: () {
        func;
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
              color: Theme.of(context).shadowColor, border: Border.all()),
          child: Row(
            children: [
              Container(
                color: Colors.white,
                child:
                    Image.asset("lib/logic/src/assets/icons/icon_google.png"),
              ),
              Gap(MediaQuery.of(context).size.width * 0.06),
              Text('Sign in with Google',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center)
            ],
          )),
    );
  }
}
