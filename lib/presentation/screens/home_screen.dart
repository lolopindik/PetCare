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
        title: Image.asset('lib/logic/src/assets/imgs/logo.png',
            height: MediaQuery.of(context).size.height * 0.3),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      ),
      body: hasPetProfileAsync.when(
        data: (hasPetProfile) {
          return hasPetProfile ? HomePage().build(context) : TemporaryPage().build(context, ref);
        },
        loading: () => const Center(child: CupertinoActivityIndicator(
              animating: true,
              radius: 15,
            ),),
        error: (err, stack) => Center(child: Text('Error on loading...')),
      ),
    );
  }
}
