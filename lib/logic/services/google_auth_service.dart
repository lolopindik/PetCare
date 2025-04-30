import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '185003222416-nc0a28522cuttu33ldhlncss7r3doa9u.apps.googleusercontent.com' : null,
    scopes: ['email'],
  );

  Future<User?> signInWithGoogle() async {
    try {
      DebugLogger.print('Starting Google Sign-In');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        DebugLogger.print('\x1B[33mGoogle Sign-In cancelled by user');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final DatabaseReference dbRef = FirebaseDatabase.instance.ref('userDetails/${user.uid}');
        await dbRef.update({
          "name": user.displayName ?? "Unknown",
          "email": user.email,
          "verify": user.emailVerified,
        });

        DebugLogger.print('\x1B[32mGoogle Sign-In successful: ${user.displayName}');
      }

      return user;
    } catch (e) {
      if (e is FirebaseAuthException) {
      } else if (e is PlatformException) {
        if (e.code == 'sign_in_failed') {
        } else if (e.code == 'network_error') {
        }
      }
      DebugLogger.print('\x1B[31mError during Google Sign-In: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      DebugLogger.print('\x1B[32mUser signed out successfully');
    } catch (e) {
      DebugLogger.print('\x1B[31mError during sign out: $e');
    }
  }
}