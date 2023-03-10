import 'package:flutter/material.dart';
import 'package:interpretasi_editor/src/common/const.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    this.controller,
    this.hintText,
    this.onSubmitted,
    this.onChanged,
    this.showBorder = false,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool showBorder;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      style: theme.textTheme.titleMedium,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium,
        helperStyle: theme.textTheme.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: Const.space12),
        enabledBorder: (showBorder == true)
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(Const.radius),
                borderSide: BorderSide(color: theme.disabledColor),
              )
            : InputBorder.none,
        focusedBorder: (showBorder == true)
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(Const.radius),
                borderSide: BorderSide(color: theme.primaryColor),
              )
            : InputBorder.none,
        errorBorder: (showBorder == true)
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(Const.radius),
                borderSide: BorderSide(color: theme.colorScheme.error),
              )
            : InputBorder.none,
        focusedErrorBorder: (showBorder == true)
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(Const.radius),
                borderSide: BorderSide(color: theme.colorScheme.error),
              )
            : InputBorder.none,
        disabledBorder: (showBorder == true)
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(Const.radius),
                borderSide: BorderSide(color: theme.disabledColor),
              )
            : InputBorder.none,
      ),
    );
  }
}
