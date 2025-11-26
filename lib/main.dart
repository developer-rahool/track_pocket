import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:trackpocket/providers/budget_provider.dart';

import 'package:trackpocket/screens/splash_screen.dart';
import 'package:trackpocket/tabbar_screen.dart';
import 'package:trackpocket/theme/app_theme.dart';
import 'package:trackpocket/notifications/notification_service.dart';
import 'package:trackpocket/providers/theme_provider.dart';
import 'package:trackpocket/providers/transaction_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize timezone for scheduled notifications
  tz.initializeTimeZones();

  /// Initialize flutter local notifications
  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<TransactionProvider>(
          create: (_) => TransactionProvider(),
        ),
        ChangeNotifierProvider<BudgetProvider>(create: (_) => BudgetProvider()),
      ],
      child: const TrackPocketApp(),
    ),
  );
}

class TrackPocketApp extends StatefulWidget {
  const TrackPocketApp({super.key});

  @override
  State<TrackPocketApp> createState() => _TrackPocketAppState();
}

class _TrackPocketAppState extends State<TrackPocketApp> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    await provider.checkGetStarted();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'TrackPocket',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: themeProvider.seenGetStarted == "true"
              ? const TabBarScreen()
              : const SplashScreen(),
        );
      },
    );
  }
}
