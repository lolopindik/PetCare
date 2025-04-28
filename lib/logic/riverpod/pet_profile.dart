import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


final hasPetProfileProvider = StreamProvider<bool>((ref) {
  
  final user = FirebaseAuth.instance.currentUser;
  final dbref = FirebaseDatabase.instance.ref('userDetails/${user?.uid}/hasPetProfile');

  return dbref.onValue.map((event) {
    final data = event.snapshot.value;
    if (data is bool) {
      return data;
    }
    return false;
  });
});
