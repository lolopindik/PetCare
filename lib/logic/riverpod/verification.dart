import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

final verifiedProvider =
    ChangeNotifierProvider<VerifiedNotifier>((ref) => VerifiedNotifier());

class VerifiedNotifier extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  late DatabaseReference dbref;
  late Box _box;

  VerifiedNotifier() {
    _init();
  }

  void _init() {
    try {
      _box = Hive.box('Entry');
      if (user != null){
        FirebaseDatabase.instance.ref("userDetails/${user!.uid}");
      }
      notifyListeners();
    } catch (e) {
      DebugLogger.print('Hive initialization failed: $e');
    }
  }
  
  Future<bool> get hasVerified async {
    return await _box.get('hasVerified', defaultValue: false) as bool;
  }

  void markVerified() async {
    _box.put('hasVerified', true);
    await dbref.update({
      "verify": true,
    });
    notifyListeners();
  }
}
