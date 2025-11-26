import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackpocket/providers/transaction_provider.dart';
import 'package:trackpocket/screens/category_screen.dart';
import 'package:trackpocket/screens/dashboard_screen.dart';
import 'package:trackpocket/screens/settings_screen.dart';
import 'package:trackpocket/screens/statics_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final List<Widget> _tabList = [
    const DashboardScreen(),
    const CategoryScreen(),
    const StaticsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    context.read<TransactionProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: _tabList[provider.selectIndex],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 2,
            type: BottomNavigationBarType.shifting,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            currentIndex: provider.selectIndex,
            showSelectedLabels: true,
            selectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.edit_document),
                label: 'List',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_rounded),
                label: 'Statics',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
            onTap: (index) {
              provider.tabListener(index);
            },
          ),
        );
      },
    );
  }
}
