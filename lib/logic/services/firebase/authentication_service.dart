// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

abstract class AuthenticationService {
  Future<void> signIn({String? emailAddress, String? password});
  Future<void> signUp({required String emailAddress, required String password});
}

class EmailSignUpService implements AuthenticationService {
  @override
  Future<void> signUp({required String emailAddress, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        DebugLogger.print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        DebugLogger.print('The account already exists for that email.');
      } else {
        DebugLogger.print('Sign-up error: ${e.code}');
      }
    } catch (e) {
      DebugLogger.print('Unexpected error: $e');
    }
  }

  @override
  Future<void> signIn({String? emailAddress, String? password}) async {
    throw UnimplementedError('Use EmailSignInService for signing in with email and password');
  }
}

class EmailSignInService implements AuthenticationService {
  @override
  Future<void> signIn({String? emailAddress, String? password}) async {
    try {
      if (emailAddress == null || password == null) {
        throw Exception('Email and password are required');
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        DebugLogger.print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        DebugLogger.print('Wrong password provided for that user.');
      } else {
        DebugLogger.print('Sign-in error: ${e.code}');
      }
    } catch (e) {
      DebugLogger.print('Unexpected error: $e');
    }
  }

  @override
  Future<void> signUp({required String emailAddress, required String password}) async {
    throw UnimplementedError('Use EmailSignUpService for signing up with email and password');
  }
}

class GoogleSignInService implements AuthenticationService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<void> signIn({String? emailAddress, String? password}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        DebugLogger.print('Google Sign-In cancelled');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      DebugLogger.print('Google Sign-In error: ${e.code}');
    } catch (e) {
      DebugLogger.print('Unexpected error: $e');
    }
  }

  @override
  Future<void> signUp({required String emailAddress, required String password}) async {
    throw UnimplementedError('Google Sign-In does not support email/password sign-up');
  }
}