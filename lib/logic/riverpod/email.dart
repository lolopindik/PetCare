import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailProvider =
    ChangeNotifierProvider<EmailNotifier>((ref) => EmailNotifier());

class EmailNotifier extends ChangeNotifier {
  String? _email;

  EmailNotifier() {
    _init();
  }

  Future<void> _init() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      notifyListeners();
      return;
    }

    DatabaseReference dbref = FirebaseDatabase.instance.ref();
    final snapshot = await dbref.child('userDetails/${user.uid}/email').get();
    _email = snapshot.value?.toString();
    notifyListeners();
  }

  String? get email => _email;
}
