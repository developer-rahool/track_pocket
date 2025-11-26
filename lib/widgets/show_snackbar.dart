// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:trackpocket/utiles/const.dart';

class ShowCustomSnackBar extends StatelessWidget {
  String msg;
  Color? color;
  ShowCustomSnackBar({super.key, required this.msg, this.color});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: SnackBar(
        padding: const EdgeInsets.all(12),
        backgroundColor: color ?? whiteColor,
        content: Text(
          msg,
          style: const TextStyle(fontSize: 14, color: chrome900),
        ),
      ),
    );
  }
}
