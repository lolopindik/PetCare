import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

final verifiedProvider =
    ChangeNotifierProvider<VerifiedNotifier>((ref) => VerifiedNotifier());

class VerifiedNotifier extends ChangeNotifier {
  final User? user = FirebaseAuth.instance.currentUser;
  late DatabaseReference dbref;
  late Box _box;

  VerifiedNotifier() {
    _init();
  }

  void _init() {
    try {
      _box = Hive.box('Entry');
      if (user != null) {
        dbref = FirebaseDatabase.instance.ref("userDetails/${user!.uid}");
      }
      notifyListeners();
    } catch (e) {
      DebugLogger.print('Hive initialization failed: $e');
    }
  }

  Future<bool> get hasVerified async {
    if (user != null) {
      await user!.reload();
      final isEmailVerified = user!.emailVerified;
      await _box.put('hasVerified', isEmailVerified);
      await dbref.update({"verify": isEmailVerified});
      return isEmailVerified;
    }
    return await _box.get('hasVerified', defaultValue: false) as bool;
  }

  Future<void> setVerified(bool isVerified) async {
    try {
      await _box.put('hasVerified', isVerified);
      if (user != null) {
        await dbref.update({"verify": isVerified});
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
      if (user != null && !user!.emailVerified) {
        await FirebaseAuth.instance.setLanguageCode("en");
        await user!.sendEmailVerification();
        DebugLogger.print('Verification email sent successfully');
      } else {
        DebugLogger.print('User is null or already verified');
      }
    } catch (e) {
      DebugLogger.print('Error sending verification email: $e');
      rethrow;
    }
  }
}