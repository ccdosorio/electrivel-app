// Flutter
import 'package:flutter/material.dart';
// Internal dependencies
import 'package:electrivel_app/config/config.dart';

class CustomFormDropDown<T, V> extends StatelessWidget {
  final V? value;
  final String? labelText;
  final List<T> options;
  final Widget Function(T) getLabel;
  final V Function(T) getValue;
  final bool Function(T value)? active;
  final int Function(T a, T b)? sortBy;
  final ValueChanged<V?>? onChanged;
  final FormFieldValidator<V>? validator;

  const CustomFormDropDown(
      {super.key,
        this.value,
        required this.options,
        this.onChanged,
        required this.getValue,
        required this.getLabel,
        this.active,
        this.sortBy,
        this.labelText, this.validator});

  @override
  Widget build(BuildContext context) {
    final items = buildDropdownItems(
      context: context,
      options: options,
      getValue: getValue,
      getLabel: getLabel,
      sortBy: sortBy,
      active: active
    );
    return DropdownButtonFormField(
      initialValue: value,
      decoration: InputDecorations.decoration(labelText: labelText),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }

  List<DropdownMenuItem<V>> buildDropdownItems({
    required BuildContext context,
    required List<T> options,
    required V Function(T) getValue,
    required Widget Function(T) getLabel,
    required bool Function(T value)? active,
  int Function(T a, T b)? sortBy,
  }) {
    if (sortBy != null) {
      options.sort(sortBy);
    }

    final disabledColor = Theme.of(context).disabledColor;

    return options.map((option) {
      final isEnabled = active == null ? true : active(option);
      final label = getLabel(option);

      final styledChild = isEnabled
          ? label
          : IconTheme.merge(
        data: IconThemeData(color: disabledColor),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: disabledColor),
          child: label,
        ),
      );

      return DropdownMenuItem<V>(
        value: getValue(option),
        enabled: isEnabled,
        child: styledChild,
      );
    }).toList();
  }
}
