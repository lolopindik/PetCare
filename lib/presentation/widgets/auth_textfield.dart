
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_care/logic/riverpod/obscure_text.dart';
import 'package:pet_care/logic/riverpod/textfield_handler.dart';

class AuthTextfieldWidget {
  Widget build(
    BuildContext context,
    String title,
    WidgetRef ref,
    String fieldId,
    bool ishiden,
  ) {
    final controller = ref.watch(textFieldControllerProvider(fieldId));

    return TextField(
      controller: controller,
      obscureText: ishiden && ref.watch(isPasswordVisible),
      maxLines: 1,
      decoration: InputDecoration(
        hintText: '$title:',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
        suffixIcon:
            ishiden
                ? IconButton(
                  icon: Icon(
                    ref.watch(isPasswordVisible)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    ref
                        .read(isPasswordVisible.notifier)
                        .update((state) => !state);
                  },
                )
                : null,
      ),
    );
  }
}