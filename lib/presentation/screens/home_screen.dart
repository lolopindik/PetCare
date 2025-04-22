import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/presentation/pages/home_page.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        centerTitle: true,
        title: Image.asset('lib/logic/src/assets/imgs/logo.png',
            height: MediaQuery.of(context).size.height * 0.3),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      ),
      body: HomePage().build(context),
    );
  }
}
