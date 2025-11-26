import 'package:flutter/material.dart';
import 'package:trackpocket/models/transaction_model.dart';

class CategoryFilterProvider with ChangeNotifier {
  final now = DateTime.now();

  String filterCategoyTypeName = 'All Transaction';

  final List<String> filterCategoyType = [
    'All Transaction',
    'Weekly',
    'Monthly',
    '3 Months',
    'Custom Range',
  ];

  FilterRangeType _filterRangeType = FilterRangeType.all;

  DateTime? _customStartDate;
  DateTime? _customEndDate;
  DateTime selectedDate = DateTime.now();

  bool incomebuttonTap = false;
  bool expensebuttonTap = true;

  FilterIncome _filterIncome = FilterIncome.expense;

  void onRangeFilterChanged(String value) {
    filterCategoyTypeName = value;

    switch (value) {
      case "Weekly":
        _filterRangeType = FilterRangeType.weekly;
        break;
      case "Monthly":
        _filterRangeType = FilterRangeType.monthly;
        break;
      case "3 Months":
        _filterRangeType = FilterRangeType.threemonths;
        break;
      case "Custom Range":
        _filterRangeType = FilterRangeType.custom;
        break;
      default:
        _filterRangeType = FilterRangeType.all;
    }

    notifyListeners();
  }

  void setCustomRange(DateTime start, DateTime end) {
    _customStartDate = start;
    _customEndDate = end;
    notifyListeners();
  }

  // Filtering logic using transaction list from TransactionProvider
  List<TransactionModel> applyFilters(List<TransactionModel> txs) {
    List<TransactionModel> base = [];

    switch (_filterRangeType) {
      case FilterRangeType.weekly:
        DateTime weekAgo = now.subtract(const Duration(days: 7));
        base = txs.where((tx) => tx.date.isAfter(weekAgo)).toList();
        break;

      case FilterRangeType.monthly:
        base = txs
            .where(
              (tx) => tx.date.year == now.year && tx.date.month == now.month,
            )
            .toList();
        break;

      case FilterRangeType.threemonths:
        DateTime threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        base = txs.where((tx) => tx.date.isAfter(threeMonthsAgo)).toList();
        break;

      case FilterRangeType.custom:
        if (_customStartDate != null && _customEndDate != null) {
          base = txs.where((tx) {
            return tx.date.isAfter(_customStartDate!) &&
                tx.date.isBefore(_customEndDate!);
          }).toList();
        }
        break;

      case FilterRangeType.all:
        base = txs;
    }

    // Income / Expense filter
    switch (_filterIncome) {
      case FilterIncome.income:
        return base.where((tx) => tx.isIncome).toList();

      case FilterIncome.expense:
        return base.where((tx) => !tx.isIncome).toList();

      case FilterIncome.all:
        return base;
    }
  }

  // Income buttons
  void incomeButtonListen() {
    incomebuttonTap = true;
    expensebuttonTap = false;
    _filterIncome = FilterIncome.income;
    notifyListeners();
  }

  void expenseButtonListen() {
    incomebuttonTap = false;
    expensebuttonTap = true;
    _filterIncome = FilterIncome.expense;
    notifyListeners();
  }
}

enum FilterRangeType { all, weekly, monthly, threemonths, custom }

enum FilterIncome { all, income, expense }
