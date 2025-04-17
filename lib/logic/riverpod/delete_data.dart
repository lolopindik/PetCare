import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:pet_care/logic/funcs/debug_logger.dart';


final userDeletionProvider = StateNotifierProvider<UserDeletionNotifier, bool>(
  (ref) => UserDeletionNotifier(),
);

class UserDeletionNotifier extends StateNotifier<bool> {
  UserDeletionNotifier() : super(false);
  Timer? _timer;

  void scheduleDeletion(String userId) async {
    state = true;
    _timer = Timer(const Duration(seconds: 30), () async {
      await _deleteUserDataAndAccount(userId);
      state = false;
    });
  }

  Future<void> deleteUserDataImmediately(String userId) async {
    _timer?.cancel();
    await _deleteUserDataAndAccount(userId);
    state = false;
  }

  Future<void> _deleteUserDataAndAccount(String userId) async {
    try {
      await FirebaseDatabase.instance
          .ref()
          .child('userDetails')
          .child(userId)
          .remove();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }
    } catch (e) {
      DebugLogger.print('Error deleting user data or account: $e');
      rethrow;
    }
  }

  void cancelDeletion() {
    _timer?.cancel();
    state = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
