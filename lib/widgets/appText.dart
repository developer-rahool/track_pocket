// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:trackpocket/utiles/const.dart';

// ignore: must_be_immutable
class AppTextTitle extends StatelessWidget {
  String title;
  double? fontSize;
  Color? color;
  FontWeight? fontWeight;
  AppTextTitle({
    super.key,
    required this.title,
    this.fontSize,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: "Acme",
        fontSize: fontSize ?? 22,
        fontWeight: fontWeight,
        color: color ?? chrome900,
      ),
    );
  }
}
