import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

class Observer extends ProviderObserver {
  static const String reset = '\x1B[0m';
  static const String green = '\x1B[32m';
  static const String cyan = '\x1B[36m';
  static const String red = '\x1B[31m';

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    DebugLogger.print('$cyan🔄 [Provider Updated] ${provider.name ?? provider.runtimeType}: $newValue$reset',);
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    super.didAddProvider(provider, value, container);
    DebugLogger.print('$green✅ [Provider Added] ${provider.name ?? provider.runtimeType}: $value$reset',);
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {
    super.didDisposeProvider(provider, container);
    DebugLogger.print('$red❌ [Provider Disposed] ${provider.name ?? provider.runtimeType}$reset',);
  }
}