import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ItemInfoPage {
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child: Text('Info about item'));
  }
}
