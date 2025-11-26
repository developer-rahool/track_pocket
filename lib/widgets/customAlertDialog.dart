// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:trackpocket/utiles/const.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  dynamic Function()? onActionPressed;
  String? title;
  String? desciption;
  CustomAlertDialogWidget({
    super.key,
    required this.onActionPressed,
    required this.title,
    required this.desciption,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: whiteColor,
      title: Text(
        title!,
        style: const TextStyle(color: chrome800, fontWeight: FontWeight.bold),
      ),
      content: Text(desciption!, style: const TextStyle(color: chrome700)),
      actions: [
        TextButton(
          onPressed: onActionPressed,
          child: Text(title!, style: const TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(color: chrome800)),
        ),
      ],
    );
  }
}
