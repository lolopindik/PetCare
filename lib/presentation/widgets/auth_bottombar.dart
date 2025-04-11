import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/bottombar_index.dart';

class BottomBarWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: ref.watch(indexProvired).index,
      onTap: (index) {
        ref.read(indexProvired).currentIndex(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.app_registration,),
          label: 'Sign up',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login,),
          label: 'Sign in',
        ),
      ],
    );
  }
}