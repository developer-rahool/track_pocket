import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trackpocket/models/transaction_model.dart';
import 'package:trackpocket/notifications/budget_storage_helper.dart'
    show BudgetStorage;

class BudgetProvider with ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool dailyButtonTap = true;
  bool weeklyButtonTap = false;

  //Stored/Show Values
  TextEditingController budgetController = TextEditingController();
  String limitMode = "Daily";
  String budgetControllerText = "";

  budgetControllerTextUpdate(String value) {
    budgetControllerText = value;
    notifyListeners();
  }

  dailyButtonTapListen() {
    limitMode = "Daily";
    dailyButtonTap = true;
    weeklyButtonTap = false;
    notifyListeners();
  }

  weeklyButtonTapListen() {
    limitMode = "Weekly";
    dailyButtonTap = false;
    weeklyButtonTap = true;
    notifyListeners();
  }

  loadBudget() async {
    budgetControllerText = "";
    budgetController.clear();

    String? value = await BudgetStorage.getBudget("budget_value");
    String? mode = await BudgetStorage.getBudget("budget_mode");
    if (value != null && mode != null) {
      budgetControllerText = value;
      budgetController.text = "$value\$";
      if (mode == "Daily") {
        dailyButtonTapListen();
      } else {
        weeklyButtonTapListen();
      }
    }
  }

  bool isLoading = false;
  isLoadingListen(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> checkLimitExceeded(List<TransactionModel> list) async {
    final String? value = await BudgetStorage.getBudget("budget_value");
    final String? mode = await BudgetStorage.getBudget("budget_mode");

    if (value == null || mode == null) return;

    final double limit = double.parse(value);

    double totalSpent = 0;

    // Calculate based on mode
    if (mode == "Daily") {
      final now = DateTime.now();
      totalSpent = list
          .where(
            (tx) =>
                !tx.isIncome &&
                tx.date.year == now.year &&
                tx.date.month == now.month &&
                tx.date.day == now.day,
          )
          .fold(0, (sum, tx) => sum + tx.amount);
    } else if (mode == "Weekly") {
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final sunday = monday.add(const Duration(days: 6));

      totalSpent = list
          .where(
            (tx) =>
                !tx.isIncome &&
                tx.date.isAfter(monday.subtract(const Duration(seconds: 1))) &&
                tx.date.isBefore(sunday.add(const Duration(days: 1))),
          )
          .fold(0, (sum, tx) => sum + tx.amount);
    }

    if (totalSpent > limit) {
      await showExceededLimitNotification(value, mode);
    }
  }

  Future<void> showExceededLimitNotification(String value, String mode) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'limit_exceeded_channel',
        'Limit Exceeded',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      '$value Exceeded!',
      'You have exceeded your $mode limit!',
      details,
    );
  }
}
