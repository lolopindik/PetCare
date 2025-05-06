
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

final stepProvider = ChangeNotifierProvider<StepNotifier>((ref){
  return StepNotifier();
});

final typeProvder = ChangeNotifierProvider<TypeNotifier>((ref){
  return TypeNotifier();
});

class StepNotifier extends ChangeNotifier{
  int step = 1;
  int maxSteps = 3;

  void incrementStep(){
    step++;
    DebugLogger.print('Current step: $step');
    notifyListeners();
  }

  void decrementStep(){
    step--;
    DebugLogger.print('Current step: $step');
    notifyListeners();
  }
}

class TypeNotifier extends ChangeNotifier{
  int index = -1;

  void togleType(int newIndex){
    index = newIndex;
    notifyListeners();
  }
}