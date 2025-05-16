import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final breedProvider = ChangeNotifierProvider((ref) => BreedNotifier());

class BreedNotifier extends ChangeNotifier {
  int selectedIndex = -1;
  String selectedName = '';

  void selectBreed(int newIndex, String newName) {
    selectedIndex = newIndex;
    selectedName = newName;
    notifyListeners();
  }

  void clearSelection() {
    selectedIndex = -1;
    selectedName = '';
    notifyListeners();
  }
}
