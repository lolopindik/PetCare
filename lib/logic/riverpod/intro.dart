import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

final introProvider = ChangeNotifierProvider<IntroNotifier>((ref) => IntroNotifier(
  
));

class IntroNotifier extends ChangeNotifier {
  late Box _box;

  IntroNotifier() {
    _init();
  }

  void _init() async {
  try {
    _box = Hive.box('Entry');
    notifyListeners();
  } catch (e) {
    debugPrint('Hive initialization failed: $e');
  }
}

  Future<bool> get hasSeenIntro async {
  return await _box.get('hasSeenIntro', defaultValue: false) as bool;
}

  void markIntroAsSeen() {
    _box.put('hasSeenIntro', true);
    notifyListeners(); 
  }
}