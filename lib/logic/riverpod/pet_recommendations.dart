// lib/logic/riverpod/pet_recommendations.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/services/firebase/pets_service.dart';
import 'package:pet_care/logic/services/firebase/user_service.dart';

final petRecommendationProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final userId = await UserService.getUserUuid();
  if (userId == 'unknown') return null;

  final petId = await PetsService().getFirstPetId(userId);
  if (petId == null) return null;

  final dbRef = FirebaseDatabase.instance.ref('userDetails/$userId/Pets/$petId');
  final snapshot = await dbRef.once();

  if (snapshot.snapshot.value != null) {
    return Map<String, dynamic>.from(snapshot.snapshot.value as Map);
  }
  return null;
});

final foodProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final petData = await ref.watch(petRecommendationProvider.future);
  final conditions = petData?['HealthConditions']['hasNoConditions'] == true
      ? ['none']
      : (petData?['HealthConditions']['conditions'] as List<dynamic>?) ?? [];

  final dbRef = FirebaseDatabase.instance.ref('food');
  final snapshot = await dbRef.once();

  if (snapshot.snapshot.value == null) return [];

  // Cast to List<dynamic> since Firebase returns a list
  final foods = snapshot.snapshot.value as List<dynamic>?;
  if (foods == null) return [];

  return foods
      .asMap()
      .entries
      .where((entry) => entry.value != null)
      .map((entry) => Map<String, dynamic>.from(entry.value as Map))
      .where((food) {
        final foodConditions = food['conditions'] as List<dynamic>? ?? [];
        return foodConditions.any((c) => conditions.contains(c)) &&
            food['type'] == petData?['BaseInfo']['type'];
      })
      .toList();
});

final vitaminsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final petData = await ref.watch(petRecommendationProvider.future);
  final conditions = petData?['HealthConditions']['hasNoConditions'] == true
      ? ['none']
      : (petData?['HealthConditions']['conditions'] as List<dynamic>?) ?? [];

  final dbRef = FirebaseDatabase.instance.ref('vitamins');
  final snapshot = await dbRef.once();

  if (snapshot.snapshot.value == null) return [];

  // Cast to List<dynamic> since Firebase returns a list
  final vitamins = snapshot.snapshot.value as List<dynamic>?;
  if (vitamins == null) return [];

  return vitamins
      .asMap()
      .entries
      .where((entry) => entry.value != null)
      .map((entry) => Map<String, dynamic>.from(entry.value as Map))
      .where((vitamin) {
        final vitaminConditions = vitamin['conditions'] as List<dynamic>? ?? [];
        return vitaminConditions.any((c) => conditions.contains(c)) &&
            vitamin['type'] == petData?['BaseInfo']['type'];
      })
      .toList();
});

final medicinesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final petData = await ref.watch(petRecommendationProvider.future);
  final conditions = petData?['HealthConditions']['hasNoConditions'] == true
      ? ['none']
      : (petData?['HealthConditions']['conditions'] as List<dynamic>?) ?? [];

  final dbRef = FirebaseDatabase.instance.ref('medicines');
  final snapshot = await dbRef.once();

  if (snapshot.snapshot.value == null) return [];

  // Cast to List<dynamic> since Firebase returns a list
  final medicines = snapshot.snapshot.value as List<dynamic>?;
  if (medicines == null) return [];

  return medicines
      .asMap()
      .entries
      .where((entry) => entry.value != null)
      .map((entry) => Map<String, dynamic>.from(entry.value as Map))
      .where((medicine) {
        final medicineConditions = medicine['conditions'] as List<dynamic>? ?? [];
        return medicineConditions.any((c) => conditions.contains(c)) &&
            medicine['type'] == petData?['BaseInfo']['type'];
      })
      .toList();
});