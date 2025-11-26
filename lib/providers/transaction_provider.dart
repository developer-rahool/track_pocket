import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trackpocket/models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final now = DateTime.now();
  DateTime selectedDate = DateTime.now();
  var selectIndex = 0;
  bool isLoading = false;
  bool dailybuttonTap = true;
  bool monthlybuttonTap = false;
  bool incomebuttonTap = false;
  bool expensebuttonTap = true;

  final _storage = const FlutterSecureStorage();
  String selectedCategory = 'General';
  final String _storageKey = 'transactions';
  double remainingBalance = 0.0;
  double totalExpense = 0.0;
  double totalDeposite = 0.0;

  List<TransactionModel> _transactions = [];

  final List<String> categories = [
    'General',
    'Food',
    'Transport',
    'Shopping',
    'Rent',
    "Fuel",
    'Investment',
    'Medical',
    'Entertainment',
    'Utilities',
    "Salary",
  ];
  bool isIncome = false;

  categoryDropDownListen(String value) {
    selectedCategory = value;
    if (selectedCategory == "Salary") {
      isIncome = true;
    } else {
      isIncome = false;
    }
    notifyListeners();
  }

  switchListTileFun(bool value) {
    if (value == true) {
      selectedCategory = 'Salary';
    } else {
      selectedCategory = 'General';
    }
    isIncome = value;
    notifyListeners();
  }

  List<TransactionModel> get transactions => _transactions;

  Future<void> loadTransactions() async {
    isLoading = true;
    final data = await _storage.read(key: _storageKey);
    remainingBalance = 0.0;
    totalExpense = 0.0;
    totalDeposite = 0.0;
    if (data != null) {
      List<dynamic> jsonList = jsonDecode(data);
      _transactions = jsonList
          .map((json) => TransactionModel.fromJson(json))
          .toList();
      double totalAmount = _transactions
          .where((tx) => tx.date.month == now.month)
          .fold(0.0, (sum, tx) => sum + tx.amount);
      if (totalAmount != 0.0) {
        totalDeposite = _transactions
            .where((tx) => tx.isIncome && tx.date.month == now.month)
            .fold(0.0, (sum, tx) => sum + tx.amount);
        totalExpense = totalAmount - totalDeposite;
        remainingBalance = totalDeposite - totalExpense;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  isLoadingListen(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    _transactions.add(tx);
    await _saveToStorage();
    // await checkLimitExceeded();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((tx) => tx.id == id);
    await _saveToStorage();
    notifyListeners();
  }

  void clearAllTransactions() async {
    _transactions.clear();
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final jsonList = _transactions.map((tx) => tx.toJson()).toList();
    await _storage.write(key: _storageKey, value: jsonEncode(jsonList));
  }

  //Tab Bar Listener

  tabListener(int value) {
    selectIndex = value;
    notifyListeners();
  }

  //
  FilterType _filter = FilterType.daily;
  FilterType get filter => _filter;

  void setFilter(FilterType type) {
    _filter = type;
    notifyListeners();
  }

  List<TransactionModel> get filteredTransactions {
    switch (_filter) {
      case FilterType.daily:
        return _transactions.where((tx) {
          return tx.date.year == now.year &&
              tx.date.month == now.month &&
              tx.date.day == now.day;
        }).toList();

      case FilterType.monthly:
        return _transactions.where((tx) {
          return tx.date.year == now.year && tx.date.month == now.month;
        }).toList();
    }
  }

  dailyButtonListen() {
    dailybuttonTap = true;
    monthlybuttonTap = false;
    setFilter(FilterType.daily);
    notifyListeners();
  }

  monthlyButtonListen() {
    dailybuttonTap = false;
    monthlybuttonTap = true;
    setFilter(FilterType.monthly);
    notifyListeners();
  }

  //
  final Map<String, String> categoryIcons = {
    "General": "",
    "Food": "assets/icons/food_icon.png",
    "Transport": "assets/icons/transport_icon.png",
    "Shopping": "assets/icons/shopping_icon.png",
    "Rent": "assets/icons/rent_icon.png",
    "Fuel": "assets/icons/petrol_icon.png",
    "Investment": "assets/icons/investment_icon.png",
    "Medical": "assets/icons/medical_icon.png",
    "Entertainment": "assets/icons/movie_icon.png",
    "Utilities": "assets/icons/utilities_icon.png",
    "Salary": "assets/icons/salary_icon.png",
  };
  ////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////
  ////////////// Category Screen Provider //////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////
  ///
  String filterCategoyTypeName = 'All Transaction';
  final List<String> filterCategoyType = [
    'All Transaction',
    'Weekly',
    'Monthly',
    '3 Months',
    'Custom Range',
  ];

  FilterRangeType _filterRangeType = FilterRangeType.all;
  // FilterRangeType get filterRangeType => _filterRangeType;

  void setRangeFilter(FilterRangeType type) {
    _filterRangeType = type;
    notifyListeners();
  }

  DateTime? _customStartDate;
  DateTime? _customEndDate;

  void setCustomRange(DateTime start, DateTime end) {
    _customStartDate = start;
    _customEndDate = end;
    notifyListeners();
  }

  List<TransactionModel> get filteredRangeTransactions {
    switch (_filterRangeType) {
      case FilterRangeType.weekly:
        DateTime weekAgo = now.subtract(Duration(days: 7));
        return _transactions
            .where(
              (tx) =>
                  tx.date.isAfter(weekAgo) &&
                  tx.date.isBefore(now.add(Duration(days: 1))),
            )
            .toList();
      case FilterRangeType.monthly:
        return _transactions.where((tx) {
          return tx.date.year == now.year && tx.date.month == now.month;
        }).toList();

      case FilterRangeType.threemonths:
        DateTime threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return _transactions
            .where(
              (tx) =>
                  tx.date.isAfter(threeMonthsAgo.subtract(Duration(days: 1))) &&
                  tx.date.isBefore(now.add(Duration(days: 1))),
            )
            .toList();

      case FilterRangeType.custom:
        if (_customStartDate == null || _customEndDate == null) {
          return _transactions;
        }
        return _transactions
            .where(
              (tx) =>
                  tx.date.isAfter(
                    _customStartDate!.subtract(Duration(days: 1)),
                  ) &&
                  tx.date.isBefore(_customEndDate!.add(Duration(days: 1))),
            )
            .toList();

      case FilterRangeType.all:
        return _transactions;
    }
  }

  onRangeFilterChanged(String value) {
    filterCategoyTypeName = value;

    switch (value) {
      case "Weekly":
        setRangeFilter(FilterRangeType.weekly);
        break;
      case "Monthly":
        setRangeFilter(FilterRangeType.monthly);
        break;
      case "3 Months":
        setRangeFilter(FilterRangeType.threemonths);
        break;
      case "Custom Range":
        setRangeFilter(FilterRangeType.custom);
        break;
      case 'All Transaction':
        setRangeFilter(FilterRangeType.all);
        break;
    }
  }

  pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: now,
    );

    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  ///////////////////////////////////// INCOME
  FilterIncome _filterIncome = FilterIncome.expense;
  // FilterIncome get filterIncome => _filterIncome;
  setFilterIncome(FilterIncome type) {
    _filterIncome = type;
  }

  List<TransactionModel> get filteredIncomeTransactions {
    switch (_filterIncome) {
      case FilterIncome.income:
        return filteredRangeTransactions.where((tx) => tx.isIncome).toList();

      case FilterIncome.expense:
        return filteredRangeTransactions.where((tx) => !tx.isIncome).toList();
      case FilterIncome.all:
        return filteredRangeTransactions;
    }
  }

  incomeButtonListen() {
    incomebuttonTap = true;
    expensebuttonTap = false;
    setFilterIncome(FilterIncome.income);
    notifyListeners();
  }

  expenseButtonListen() {
    incomebuttonTap = false;
    expensebuttonTap = true;
    setFilterIncome(FilterIncome.expense);
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////
  ////////////// Statics Screen Provider //////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////
  ///
  String filterStaticsName = 'All Transaction';
  final List<String> filterStaticsNameCategory = [
    'All Transaction',
    'Daily',
    'Weekly',
    'Monthly',
    '3 Months',
  ];

  FilterStaticsType _filterStaticsType = FilterStaticsType.all;

  void setfilterStatics(FilterStaticsType type) {
    _filterStaticsType = type;
    notifyListeners();
  }

  final Map<String, double> staticsCategoryTotals = {};

  List<TransactionModel> get filteredStaticsCategory {
    switch (_filterStaticsType) {
      case FilterStaticsType.daily:
        return _transactions.where((tx) {
          return tx.date.year == now.year &&
              tx.date.month == now.month &&
              tx.date.day == now.day;
        }).toList();

      case FilterStaticsType.weekly:
        DateTime weekAgo = now.subtract(Duration(days: 7));
        return _transactions
            .where(
              (tx) =>
                  tx.date.isAfter(weekAgo) &&
                  tx.date.isBefore(now.add(Duration(days: 1))),
            )
            .toList();
      case FilterStaticsType.monthly:
        return _transactions.where((tx) {
          return tx.date.year == now.year && tx.date.month == now.month;
        }).toList();

      case FilterStaticsType.threemonths:
        DateTime threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return _transactions
            .where(
              (tx) =>
                  tx.date.isAfter(threeMonthsAgo.subtract(Duration(days: 1))) &&
                  tx.date.isBefore(now.add(Duration(days: 1))),
            )
            .toList();

      case FilterStaticsType.all:
        return _transactions;
    }
  }

  void onStaticsFilterChanged(String value) {
    filterStaticsName = value;
    switch (value) {
      case "Daily":
        setfilterStatics(FilterStaticsType.daily);
        break;
      case "Weekly":
        setfilterStatics(FilterStaticsType.weekly);
        break;
      case "Monthly":
        setfilterStatics(FilterStaticsType.monthly);
        break;
      case "3 Months":
        setfilterStatics(FilterStaticsType.threemonths);
        break;
      default:
        setfilterStatics(FilterStaticsType.all);
    }
  }

  Map<String, double> calculateStaticsTotals() {
    Map<String, double> totals = {};

    for (var tx in filteredStaticsCategory) {
      totals[tx.category] = (totals[tx.category] ?? 0) + tx.amount;
    }

    return totals;
  }
}

//Dashboard
enum FilterType { daily, monthly }

//List
enum FilterRangeType { all, weekly, monthly, threemonths, custom }

enum FilterIncome { all, income, expense }

//Statics
enum FilterStaticsType { all, daily, weekly, monthly, threemonths }
