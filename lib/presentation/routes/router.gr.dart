// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:pet_care/presentation/screens/auth_screen.dart' as _i1;
import 'package:pet_care/presentation/screens/recovery_screen.dart' as _i2;
import 'package:pet_care/presentation/screens/splash_screen.dart' as _i3;
import 'package:pet_care/presentation/screens/verify_screen.dart' as _i4;
import 'package:pet_care/presentation/screens/welcome_screen.dart' as _i5;

/// generated route for
/// [_i1.AuthScreen]
class AuthRoute extends _i6.PageRouteInfo<void> {
  const AuthRoute({List<_i6.PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthScreen();
    },
  );
}

/// generated route for
/// [_i2.RecoveryScreen]
class RecoveryRoute extends _i6.PageRouteInfo<void> {
  const RecoveryRoute({List<_i6.PageRouteInfo>? children})
    : super(RecoveryRoute.name, initialChildren: children);

  static const String name = 'RecoveryRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.RecoveryScreen();
    },
  );
}

/// generated route for
/// [_i3.SplashScreen]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute({List<_i6.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.SplashScreen();
    },
  );
}

/// generated route for
/// [_i4.VerifyScreen]
class VerifyRoute extends _i6.PageRouteInfo<void> {
  const VerifyRoute({List<_i6.PageRouteInfo>? children})
    : super(VerifyRoute.name, initialChildren: children);

  static const String name = 'VerifyRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.VerifyScreen();
    },
  );
}

/// generated route for
/// [_i5.WelcomeScreen]
class WelcomeRoute extends _i6.PageRouteInfo<void> {
  const WelcomeRoute({List<_i6.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.WelcomeScreen();
    },
  );
}
