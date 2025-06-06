// ignore_for_file: unused_local_variable
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pet_care/data/firebase/config/firebase_options.dart';
import 'package:pet_care/logic/riverpod/observer.dart';
import 'package:pet_care/logic/riverpod/theme_switcher.dart';
import 'package:pet_care/presentation/routes/router.dart';
// import 'package:pet_care/logic/funcs/web_fix.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  //* Firebase init
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: "pet_care",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  //* For web deploy
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.web
  // );
  //* Local storage
  await Hive.initFlutter();
  var themeBox = await Hive.openBox('AppTheme');
  var entryBox = await Hive.openBox('Entry');
  runApp(ProviderScope(
    observers: [Observer()],
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter(ref);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ref.watch(themeProvider).themeData,
      routerConfig: appRouter.config(),
      //* For web deploy
      // scrollBehavior: AppScrollBehavior(),
    );
  }
}
