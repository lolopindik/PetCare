// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pet_care/logic/riverpod/observer.dart';
import 'package:pet_care/logic/riverpod/theme_switcher.dart';

Future main () async{

  await Hive.initFlutter();
  var themebox = await Hive.openBox('AppTheme');

  runApp(
    ProviderScope(
      observers: [Observer()],
      child: MyApp(),
    )
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ref.watch(themeProvider).themeData,
    );
  }
}