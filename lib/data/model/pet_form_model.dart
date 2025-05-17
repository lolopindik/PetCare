import 'package:uuid/uuid.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

abstract class Pages {
  void pageData();
}

class FirstPageModel implements Pages {
  final String id;
  final String petName;
  final int petAge;
  final double petWeight;
  final int petGender;
  final int petType;

  FirstPageModel._internal({
    required this.id,
    required this.petName,
    required this.petAge,
    required this.petWeight,
    required this.petGender,
    required this.petType,
  });

  factory FirstPageModel.initialize({
    required String petName,
    required int petAge,
    required double petWeight,
    required int petGender,
    required int petType,
  }) {
    final Uuid uuid = Uuid();
    return FirstPageModel._internal(
      id: uuid.v4(),
      petName: petName,
      petAge: petAge,
      petWeight: petWeight,
      petGender: petGender,
      petType: petType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petName': petName,
      'petAge': petAge,
      'petWeight': petWeight,
      'petGender': petGender,
      'petType': petType,
    };
  }

  @override
  void pageData() {
    DebugLogger.print("Saving first page data:");
    DebugLogger.print("Pet Name: $petName");
    DebugLogger.print("Pet Age: $petAge");
    DebugLogger.print("Pet Weight: $petWeight");
  }
}

class SecondPageModel implements Pages {
  final String breed;

  SecondPageModel({required this.breed});

    Map<String, dynamic> toMap() {
    return {
      'petBreed': breed
    };
  }

  @override
  void pageData() {
    DebugLogger.print("Saving first page data:");
    DebugLogger.print("Pet Breed: $breed");
  }
}

class ThirdPageModel implements Pages{

  Map<dynamic, dynamic> data;
  ThirdPageModel(this.data);

   @override
  void pageData() {
    DebugLogger.print("Saving third page data: ${data.toString()}");
  }
}