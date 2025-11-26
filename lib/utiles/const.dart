import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Constant value
const String iconPath = 'assets/icons';
const String imagesPath = 'assets/images';

//Constant Colors
const Color whiteColor = Colors.white;

//BlackColorss
const Color chrome100 = Color(0xffF5F5FA);
const Color chrome200 = Color.fromRGBO(235, 235, 245, 1);
const Color chrome300 = Color(0xffDDDDED);
const Color chrome400 = Color.fromRGBO(206, 206, 224, 1);
const Color chrome500 = Color.fromRGBO(167, 167, 167, 1);
const Color chrome600 = Color.fromRGBO(118, 118, 118, 1);
const Color chrome700 = Color.fromRGBO(53, 53, 56, 1);
const Color chrome800 = Color(0xff212124);
const Color chrome900 = Color(0xff111111);

screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

//Routes
nextRemovePage(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

nextPage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

final FilteringTextInputFormatter allowNumberAndDecimal =
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'));

final FilteringTextInputFormatter allowNumberOnly =
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'));
