import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackpocket/models/transaction_model.dart';
import 'package:trackpocket/providers/theme_provider.dart';
import 'package:trackpocket/providers/transaction_provider.dart';
import 'package:trackpocket/theme/app_theme.dart';
import 'package:trackpocket/utiles/const.dart';
import 'package:trackpocket/widgets/app_dropdown_field.dart';
import 'package:trackpocket/widgets/customAlertDialog.dart';
import 'package:trackpocket/widgets/custom_loader.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  ThemeProvider themeState = ThemeProvider();
  TransactionProvider txProvider = TransactionProvider();
  @override
  void initState() {
    themeState = context.read<ThemeProvider>();
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      txProvider = context.read<TransactionProvider>();
      txProvider.isLoading = true;
      txProvider.setRangeFilter(FilterRangeType.all);
      txProvider.filterCategoyTypeName = 'All Transaction';
      txProvider.setFilterIncome(FilterIncome.expense);
      txProvider.expenseButtonListen();
      txProvider.isLoading = false;
    });

    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      txProvider.setFilterIncome(FilterIncome.expense);
      txProvider.setRangeFilter(FilterRangeType.all);
      txProvider.filterCategoyTypeName = 'All Transaction';
      txProvider.expenseButtonListen();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        List<TransactionModel> txList = provider.filteredIncomeTransactions;
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: bodyPadding),
            child: provider.isLoading
                ? CustomLoader()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Filters
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 25,
                            color: themeState.isDarkMode
                                ? whiteColor
                                : chrome700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AppDropDownField(
                          value: provider.filterCategoyTypeName,
                          items: provider.filterCategoyType
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ),
                              )
                              .toList(),
                          onChanged: (value) async {
                            if (value == "Custom Range") {
                              DateTimeRange? picked = await showDateRangePicker(
                                context: context,

                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                provider.setCustomRange(
                                  picked.start,
                                  picked.end,
                                );
                              }
                            }
                            provider.onRangeFilterChanged(value);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _filterButton(
                            title: "Expense",
                            active: provider.expensebuttonTap,
                            darkMode: themeState.isDarkMode,
                            onTap: provider.expenseButtonListen,
                          ),
                          _filterButton(
                            title: "Income",
                            active: provider.incomebuttonTap,
                            darkMode: themeState.isDarkMode,
                            onTap: provider.incomeButtonListen,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      //Category
                      Expanded(
                        child: txList.isEmpty
                            ? Center(
                                child: Text(
                                  'No transactions added yet.',
                                  style: TextStyle(
                                    color: themeState.isDarkMode
                                        ? whiteColor
                                        : mainColor,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: txList.length,
                                itemBuilder: (context, index) {
                                  final tx = txList[index];
                                  return Card(
                                    color: themeState.isDarkMode
                                        ? chrome900
                                        : whiteColor,
                                    elevation: 2,
                                    child: ListTile(
                                      onLongPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialogWidget(
                                              onActionPressed: () {
                                                provider.deleteTransaction(
                                                  tx.id,
                                                );
                                                Navigator.pop(context);
                                              },
                                              title: "Delete",
                                              desciption:
                                                  "Are you Sure! you want to Delete this?",
                                            );
                                          },
                                        );
                                      },
                                      leading: _leadingIcon(provider, tx),
                                      title: Text(
                                        tx.title,
                                        style: TextStyle(
                                          color: themeState.isDarkMode
                                              ? whiteColor
                                              : chrome900,
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${tx.category} • ${tx.date.toLocal().toString().split(' ')[0]}',
                                        style: TextStyle(
                                          color: themeState.isDarkMode
                                              ? whiteColor
                                              : chrome900,
                                        ),
                                      ),
                                      trailing: Text(
                                        '${tx.isIncome ? '+ ' : '- '}\$${tx.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: tx.isIncome
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  //UI COMPONENTS
  Widget _filterButton({
    required String title,
    required bool active,
    required bool darkMode,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: active
              ? (darkMode ? Colors.white : mainColor)
              : (darkMode ? Colors.black : Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: active
                ? (darkMode ? Colors.black : Colors.white)
                : (darkMode ? Colors.white : mainColor),
          ),
        ),
      ),
    );
  }

  Widget _leadingIcon(TransactionProvider provider, TransactionModel tx) {
    if (tx.category == "General") {
      return const CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(Icons.arrow_upward, color: Colors.white),
      );
    }

    return SizedBox(
      width: 50,
      height: 50,
      child: Image.asset(
        provider.categoryIcons[tx.category]!,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
