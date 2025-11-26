import 'package:flutter/material.dart';
import 'package:trackpocket/models/transaction_model.dart';

class StaticsProvider with ChangeNotifier {
  final now = DateTime.now();

  String filterStaticsName = 'All Transaction';

  final List<String> filterStaticsNameCategory = [
    'All Transaction',
    'Daily',
    'Weekly',
    'Monthly',
    '3 Months',
  ];

  FilterStaticsType _filterStaticsType = FilterStaticsType.all;

  void onStaticsFilterChanged(String value) {
    filterStaticsName = value;

    switch (value) {
      case "Daily":
        _filterStaticsType = FilterStaticsType.daily;
        break;
      case "Weekly":
        _filterStaticsType = FilterStaticsType.weekly;
        break;
      case "Monthly":
        _filterStaticsType = FilterStaticsType.monthly;
        break;
      case "3 Months":
        _filterStaticsType = FilterStaticsType.threemonths;
        break;
      default:
        _filterStaticsType = FilterStaticsType.all;
    }

    notifyListeners();
  }

  List<TransactionModel> filterStatics(List<TransactionModel> txs) {
    switch (_filterStaticsType) {
      case FilterStaticsType.daily:
        return txs
            .where(
              (tx) =>
                  tx.date.year == now.year &&
                  tx.date.month == now.month &&
                  tx.date.day == now.day,
            )
            .toList();

      case FilterStaticsType.weekly:
        DateTime weekAgo = now.subtract(const Duration(days: 7));
        return txs.where((tx) => tx.date.isAfter(weekAgo)).toList();

      case FilterStaticsType.monthly:
        return txs
            .where(
              (tx) => tx.date.year == now.year && tx.date.month == now.month,
            )
            .toList();

      case FilterStaticsType.threemonths:
        DateTime threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return txs.where((tx) => tx.date.isAfter(threeMonthsAgo)).toList();

      case FilterStaticsType.all:
        return txs;
    }
  }
}

enum FilterStaticsType { all, daily, weekly, monthly, threemonths }
