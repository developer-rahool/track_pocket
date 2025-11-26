// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  double? size;
  CustomLoader({this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: Colors.black, value: size),
    );
  }
}
