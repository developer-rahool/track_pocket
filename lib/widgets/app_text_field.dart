// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackpocket/utiles/const.dart';

class AppTextFormField extends StatelessWidget {
  Widget? suffixIcon;
  Widget? prefixIcon;
  String title;
  TextEditingController? controller;
  int? maxLines;
  int? maxLength;
  bool obscureText;
  String? Function(String?)? validator;
  Function(String?)? onSaved;
  Function()? onEditingComplete;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  AppTextFormField({
    super.key,
    required this.title,
    this.controller,
    this.maxLength,
    this.maxLines,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.onEditingComplete,
    this.onSaved,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onEditingComplete: onEditingComplete,
      onSaved: onSaved,
      inputFormatters: inputFormatters,
      style: TextStyle(color: chrome900),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(color: chrome900),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: chrome900),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: chrome900),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: chrome900),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
      validator:
          validator ??
          (value) {
            if (value!.isEmpty) {
              return "Please Enter $title";
            }
            return null;
          },
    );
  }
}
