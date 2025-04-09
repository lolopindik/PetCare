import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/connectivity.dart';
import 'package:pet_care/presentation/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final WidgetRef ref;

  AppRouter(this.ref, {super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          guards: [AppGuard(ref: ref)],
          path: '/loading',
          initial: true,
        ),
        AutoRoute(
          page: WelcomeRoute.page,
          path: '/introduction',
          initial: false,
        )
      ];
}

class AppGuard extends AutoRouteGuard {
  final WidgetRef ref;

  AppGuard({required this.ref});

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    final connectivityStatus = ref.watch(connectivityProvider);
    if (connectivityStatus != ConnectivityResult.none) {
      router.replacePath('/introduction');
    } else {
      resolver.next(true);
    }
  }
}
