import 'package:flutter/material.dart';
import 'package:trackpocket/utiles/const.dart';

// ignore: must_be_immutable
class AppDropDownField extends StatelessWidget {
  AppDropDownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  List<DropdownMenuItem>? items;
  Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      style: TextStyle(color: chrome900),
      decoration: InputDecoration(
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
      ),
      menuMaxHeight: 200,
      borderRadius: BorderRadius.circular(10),
      isExpanded: true,
      isDense: true,
      validator: (value) {
        if (value == "select") {
          return "Please select Your categories";
        }
        return null;
      },
      dropdownColor: Colors.white,
    );
  }
}
