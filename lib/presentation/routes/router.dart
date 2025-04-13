import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/presentation/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final WidgetRef ref;

  AppRouter(this.ref, {super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: '/loading',
          initial: true,
        ),
        AutoRoute(
          page: WelcomeRoute.page,
          path: '/introduction',
        ),
        AutoRoute(
          page: AuthRoute.page,
          path: '/auth',
        ),
        AutoRoute(
          page: VerifyRoute.page,
          path: '/auth/verification',
        ),
        AutoRoute(
          page: RecoveryRoute.page,
          path: '/auth/recovery',
        ),
      ];
}
