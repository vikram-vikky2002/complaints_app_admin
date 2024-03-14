import 'package:flutter/material.dart';

class GlassTextField extends StatelessWidget {
  final TextEditingController cont;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final TextStyle? hintStyle;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final ValueNotifier<String>? valueNotifier;
  final Iterable<String>? autofillHints;

  const GlassTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.validator,
    this.valueNotifier,
    this.hintStyle,
    this.autofillHints,
    this.enabled = true,
    required this.cont,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: cont,
      enabled: enabled,
      autofillHints: autofillHints,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: validator,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        hintText: hintText,
        hintStyle: hintStyle,
        helperText: helperText,
        border: const OutlineInputBorder(),
        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 255, 255).withOpacity(1),
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: const Color.fromARGB(255, 190, 237, 232).withOpacity(0.4),
        filled: true,
      ),
    );
  }
}

class GlassDescriptionField extends StatelessWidget {
  final TextEditingController cont;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final TextStyle? hintStyle;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final ValueNotifier<String>? valueNotifier;
  final Iterable<String>? autofillHints;

  const GlassDescriptionField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.validator,
    this.valueNotifier,
    this.hintStyle,
    this.autofillHints,
    this.enabled = true,
    required this.cont,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 8,
      minLines: 3,
      controller: cont,
      enabled: enabled,
      autofillHints: autofillHints,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: validator,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        helperText: helperText,
        helperStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        border: const OutlineInputBorder(),
        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 255, 255).withOpacity(1),
              width: 2.0),
          borderRadius: BorderRadius.circular(25),
        ),
        fillColor: const Color.fromARGB(255, 190, 237, 232).withOpacity(0.4),
        filled: true,
      ),
    );
  }
}
