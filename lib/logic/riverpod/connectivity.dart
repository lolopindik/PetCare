import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityResult>(
  (ref) => ConnectivityNotifier(),
);

class ConnectivityNotifier extends StateNotifier<ConnectivityResult> {
  ConnectivityNotifier() : super(ConnectivityResult.none) {
    _init();
  }

  Future<void> _init() async {
    try {
      final initialResult = await Connectivity().checkConnectivity();
      state = initialResult.first;

      Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> result) {
        state = result.first;
        if (kDebugMode) {
          debugPrint('Connection type changed: ${result.first}');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Connectivity initialization error: $e');
      }
      state = ConnectivityResult.none;
    }
  }

  Future<void> checkConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      state = result.first;
      if (kDebugMode) {
        debugPrint('Manual check - Connection type: ${result.first}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Connectivity check error: $e');
      }
      state = ConnectivityResult.none;
    }
  }
}
