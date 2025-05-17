import 'package:firebase_database/firebase_database.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';
import 'package:pet_care/logic/services/database_service.dart';
import 'package:pet_care/logic/services/firebase/pets_service.dart';
import 'package:pet_care/logic/services/firebase/user_service.dart';

abstract class FormService {
  Future<void> saveForm(Map<String, dynamic> data);
}

class SaveFirstPage implements FormService {
  @override
  Future<void> saveForm(Map<String, dynamic> data) async {
    try {
      if (!data.containsKey('id') ||
          !data.containsKey('petName') ||
          !data.containsKey('petAge') ||
          !data.containsKey('petWeight') ||
          !data.containsKey('petGender') ||
          !data.containsKey('petType')) {
        throw ArgumentError("Invalid data: Missing required fields.");
      }

      final String uuid = await UserService.getUserUuid();

      DatabaseReference dbRef =
          await DataBaseRef().databaseRef('userDetails/$uuid/Pets');

      await dbRef.update({
        data['id']: {
          "BaseInfo": {
            "name": data['petName'],
            "age": data['petAge'],
            "weight": data['petWeight'],
            "gender": data['petGender'],
            "type": data['petType']
          }
        }
      });

      DebugLogger.print("Data saved successfully.");
    } catch (e) {
      DebugLogger.print('$e');
      rethrow;
    }
  }
}

class SaveSecondPage implements FormService {
  @override
  Future<void> saveForm(Map<String, dynamic> data) async {
    try {
      final String uuid = await UserService.getUserUuid();

      final petService = PetsService();

      final String? firstPetId = await petService.getFirstPetId(uuid);

      if (firstPetId != null) {
        final dbRef =
            FirebaseDatabase.instance.ref('userDetails/$uuid/Pets/$firstPetId');
        await dbRef.child("BaseInfo/breed").set(data['petBreed']);
      } else {
        DebugLogger.print('First pet data: EMT');
      }
    } catch (e) {
      DebugLogger.print('$e');
      rethrow;
    }
  }
}
