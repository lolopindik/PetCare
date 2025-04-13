import 'package:flutter/foundation.dart';

class DebugLogger {
  static void print(String text){
    if (kDebugMode){
      debugPrint(text);
    }
  }
}