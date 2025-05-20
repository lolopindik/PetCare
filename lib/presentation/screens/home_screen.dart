// lib/presentation/pages/home_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/pet_profile.dart';
import 'package:pet_care/presentation/pages/home_page.dart';
import 'package:pet_care/presentation/pages/temporary_page.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPetProfileAsync = ref.watch(hasPetProfileProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        centerTitle: true,
        title: Image.asset(
          'lib/logic/src/assets/imgs/logo.png',
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        leading: hasPetProfileAsync.when(
            data: (data) => (data)
                ? IconButton(
                    onPressed: () => context.router.pushPath('/settings'),
                    icon: Icon(Icons.settings))
                : SizedBox(),
            error: (err, stack) =>
                const Center(child: Text('Error on loading...')),
            loading: () => SizedBox()),
      ),
      body: hasPetProfileAsync.when(
        data: (hasPetProfile) {
          return hasPetProfile
              ? HomePage().build(context, ref) // Pass ref to build
              : TemporaryPage().build(context, ref);
        },
        loading: () => const Center(
          child: CupertinoActivityIndicator(
            animating: true,
            radius: 15,
          ),
        ),
        error: (err, stack) => const Center(child: Text('Error on loading...')),
      ),
    );
  }
}
