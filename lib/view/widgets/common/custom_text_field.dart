import 'package:dima2022/view/custom_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.initialValue,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.toExecute,
    this.onSaved,
    this.focusNode,
    this.focusNextNode,
    required this.prefixIcon,
    this.suffixIcon,
    required this.controller,
    this.validateString,
    this.validator,
    this.keyboardType,
  });

  final String hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String?>? onSaved;
  final ValueChanged<String>? toExecute;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final FocusNode? focusNode;
  final FocusNode? focusNextNode;
  final TextEditingController controller;
  final validateString;
  final validator;
  final keyboardType;
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          border: InputBorder.none,
        ),
        onChanged: onChanged,
        onSaved: onSaved,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        initialValue: controller.text,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(focusNextNode);
        },
        validator: validator ??
            (value) {
              if (value!.isEmpty) {
                return validateString;
              }
              return null;
            },
      ),
    );
  }
}
