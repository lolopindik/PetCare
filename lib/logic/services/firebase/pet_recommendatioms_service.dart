// lib/logic/services/firebase/pets_service.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

class PetsService {
  Future<String?> getFirstPetId(String userId) async {
    try {
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref('userDetails/$userId/Pets');

      final snapshot = await dbRef.once();

      if (snapshot.snapshot.value != null) {
        Map<String, dynamic> pets = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        return pets.keys.first.toString();
      } else {
        return null;
      }
    } catch (e) {
      DebugLogger.print('$e');
      rethrow;
    }
  }

  Future<void> deleteFirstPetId(String? userId) async {
    try {
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref('userDetails/$userId/Pets');

      final snapshot = await dbRef.once();

      if (snapshot.snapshot.value != null) {
        Map<String, dynamic> pets = Map<String, dynamic>.from(snapshot.snapshot.value as Map);

        if (pets.isNotEmpty) {
          String firstPetId = pets.keys.first.toString();
          await dbRef.child(firstPetId).remove();
          DebugLogger.print('Pet with ID $firstPetId deleted successfully.');
        } else {
          DebugLogger.print('No pets found for user $userId.');
        }
      } else {
        DebugLogger.print('No pets data available for user $userId.');
      }
    } catch (e) {
      DebugLogger.print('$e');
      rethrow;
    }
  }
}