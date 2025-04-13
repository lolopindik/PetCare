import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AuthGoogleWidget {
  Widget build(BuildContext context, VoidCallback func) {
    return GestureDetector(
      onTap: func,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 350
        ),
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                "lib/logic/src/assets/icons/icon_google.png",
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
            const Gap(12), // Fixed spacing
            Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}