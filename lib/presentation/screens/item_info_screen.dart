import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/presentation/pages/item_info_page.dart';

@RoutePage()
class ItemInfoScreen extends ConsumerWidget {
  const ItemInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ItemInfoPage().build(context, ref),
    );
  }
}