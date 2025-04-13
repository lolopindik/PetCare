import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

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
        DebugLogger.print('Connection type changed: ${result.first}');
      });
    } catch (e) {
      DebugLogger.print('Connectivity initialization error: $e');
      state = ConnectivityResult.none;
    }
  }

  Future<void> checkConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      state = result.first;

      DebugLogger.print('Manual check - Connection type: ${result.first}');

      DebugLogger.print('');
    } catch (e) {
      DebugLogger.print('Connectivity check error: $e');

      DebugLogger.print('');
      state = ConnectivityResult.none;
    }
  }
}
