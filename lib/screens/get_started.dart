import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trackpocket/tabbar_screen.dart';
import 'package:trackpocket/theme/app_theme.dart';
import 'package:trackpocket/utiles/const.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Padding(
        padding: const EdgeInsets.only(
          right: 30,
          left: 30,
          top: 200,
          bottom: 80,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: chrome200,
                        ),
                        child: Center(
                          child: Image.asset(
                            "$imagesPath/trackpocket1.png",
                            color: subMainColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "TrackPocket",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your Personal Expense Manager",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Stay financially organized.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            /// GET STARTED BUTTON
            SizedBox(
              height: 50,
              width: screenWidth(context),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: subMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.002),
                    Text(
                      "Get Started",
                      style: const TextStyle().copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  final storage = FlutterSecureStorage();
                  nextRemovePage(context, TabBarScreen());
                  await storage.write(key: "get_started", value: "true");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
