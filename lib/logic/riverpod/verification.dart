import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

final verifiedProvider =
    ChangeNotifierProvider<VerifiedNotifier>((ref) => VerifiedNotifier());

class VerifiedNotifier extends ChangeNotifier {
  User? user;
  late Box _box;

  VerifiedNotifier() {
    _init();
  }

  DatabaseReference? get dbref {
    if (user != null) {
      return FirebaseDatabase.instance.ref("userDetails/${user!.uid}");
    }
    return null;
  }

  void _init() {
    try {
      _box = Hive.box('Entry');
      _refreshUser();
      notifyListeners();
    } catch (e) {
      DebugLogger.print('Hive initialization failed: $e');
    }
  }

  void _refreshUser() {
    user = FirebaseAuth.instance.currentUser;
  }

  Future<bool> get hasVerified async {
    _refreshUser();
    if (user != null) {
      await user!.reload();
      final isEmailVerified = user!.emailVerified;
      await _box.put('hasVerified', isEmailVerified);
      if (dbref != null) {
        await dbref!.update({"verify": isEmailVerified});
      }
      return isEmailVerified;
    }
    return await _box.get('hasVerified', defaultValue: false) as bool;
  }

  Future<void> setVerified(bool isVerified) async {
    try {
      await _box.put('hasVerified', isVerified);
      _refreshUser();
      if (user != null && dbref != null) {
        await dbref!.update({"verify": isVerified});
      }
      notifyListeners();
    } catch (e) {
      DebugLogger.print('Error setting verified status: $e');
    }
  }

  Future<void> markVerified() async {
    try {
      await setVerified(true);
    } catch (e) {
      DebugLogger.print('Error marking verified: $e');
    }
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      _refreshUser();
      if (user == null) {
        DebugLogger.print('No user signed in');
        throw Exception('No user signed in. Please sign in again.');
      }
      if (user!.emailVerified) {
        DebugLogger.print('User email is already verified');
        await setVerified(true);
        return;
      }
      await user!.sendEmailVerification();
      DebugLogger.print('Verification email sent successfully');
    } catch (e) {
      String errorMessage = 'Failed to send verification email';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'too-many-requests':
            errorMessage = 'Too many requests. Please try again later.';
            break;
          case 'network-request-failed':
            errorMessage = 'Network error. Please check your connection.';
            break;
          default:
            errorMessage = 'Error: ${e.message}';
        }
      } else {
        errorMessage = e.toString();
      }
      DebugLogger.print('Error sending verification email: $e');
      throw Exception(errorMessage);
    }
  }
}