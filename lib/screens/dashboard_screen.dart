import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackpocket/utiles/const.dart';
import 'package:trackpocket/models/transaction_model.dart';
import 'package:trackpocket/theme/app_theme.dart';
import 'package:trackpocket/widgets/customAlertDialog.dart';
import '../providers/transaction_provider.dart';
import '../providers/theme_provider.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TransactionProvider txProvider = TransactionProvider();
  ThemeProvider themeState = ThemeProvider();
  @override
  void initState() {
    txProvider = context.read<TransactionProvider>();
    themeState = context.read<ThemeProvider>();
    txProvider.loadTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return txProvider.loadTransactions();
        },
        color: themeState.isDarkMode ? whiteColor : mainColor,
        child: Consumer<TransactionProvider>(
          builder: (context, tProvider, child) {
            List<TransactionModel> txList = tProvider.filteredTransactions;
            return Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 25,
                            color: themeState.isDarkMode
                                ? whiteColor
                                : chrome700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      //Balance Card
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: screenWidth(context) * 0.41,
                            child: Card(
                              color: subMainColor,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Balance',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          tProvider.remainingBalance.isNegative
                                              ? '-\$'
                                              : '\$',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          tProvider.remainingBalance == 0.0
                                              ? '0'
                                              : tProvider
                                                    .remainingBalance
                                                    .isNegative
                                              ? tProvider.remainingBalance
                                                    .abs()
                                                    .toString()
                                              : tProvider.remainingBalance
                                                    .toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //Expenses Card
                          SizedBox(
                            width: screenWidth(context) * 0.41,
                            child: Card(
                              color: Colors.deepOrangeAccent,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Spent',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\$',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          tProvider.totalExpense == 0.0
                                              ? '0'
                                              : tProvider.totalExpense
                                                    .toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      //Total Budget Card
                      SizedBox(
                        width: screenWidth(context),
                        child: Card(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Budget',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '\$',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      tProvider.totalDeposite == 0.0
                                          ? '0'
                                          : tProvider.totalDeposite
                                                .toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            "Filter",
                            style: TextStyle(
                              color: themeState.isDarkMode
                                  ? whiteColor
                                  : chrome700,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Daily Expense
                              SizedBox(
                                width: 95,
                                child: ElevatedButton(
                                  onPressed: () {
                                    tProvider.dailyButtonListen();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeState.isDarkMode
                                        ? !tProvider.dailybuttonTap
                                              ? Colors.black
                                              : Colors.white
                                        : tProvider.dailybuttonTap
                                        ? mainColor
                                        : chrome100,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 3,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: Text(
                                    "Daily",
                                    style: TextStyle(
                                      color: themeState.isDarkMode
                                          ? tProvider.dailybuttonTap
                                                ? Colors.black
                                                : Colors.white
                                          : !tProvider.dailybuttonTap
                                          ? mainColor
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Monthly Expense
                              SizedBox(width: 6),
                              SizedBox(
                                width: 115,
                                child: ElevatedButton(
                                  onPressed: () {
                                    tProvider.monthlyButtonListen();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeState.isDarkMode
                                        ? !tProvider.monthlybuttonTap
                                              ? Colors.black
                                              : Colors.white
                                        : tProvider.monthlybuttonTap
                                        ? mainColor
                                        : chrome100,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: Text(
                                    "Monthly",
                                    style: TextStyle(
                                      color: themeState.isDarkMode
                                          ? txProvider.monthlybuttonTap
                                                ? Colors.black
                                                : Colors.white
                                          : !txProvider.monthlybuttonTap
                                          ? mainColor
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        //Transaction List
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
                                          //txProvider.deleteTransaction(tx.id);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomAlertDialogWidget(
                                                onActionPressed: () {
                                                  txProvider.deleteTransaction(
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
                                        leading: tx.category == "General"
                                            ? SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  child: Icon(
                                                    Icons.arrow_upward,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: Image.asset(
                                                  tProvider.categoryIcons[tx
                                                      .category]!,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                        title: Text(
                                          tx.title,
                                          style: TextStyle(
                                            color: themeState.isDarkMode
                                                ? whiteColor
                                                : chrome900,
                                            fontSize: 18,
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
                                            fontSize: 14,
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
                ],
              ),
            );
          },
        ),
      ),

      // ➕ Add Transaction Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.735,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),

                    child: AddTransactionScreen(),
                  );
                },
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
