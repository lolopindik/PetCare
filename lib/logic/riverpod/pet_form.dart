
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

final stepProvider = ChangeNotifierProvider<StepNotifier>((ref){
  return StepNotifier();
});

class StepNotifier extends ChangeNotifier{
  int step = 1;
  int maxSteps = 4;

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