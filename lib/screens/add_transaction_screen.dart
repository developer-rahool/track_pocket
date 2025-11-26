// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackpocket/providers/budget_provider.dart';
import 'package:trackpocket/theme/app_theme.dart';
import 'package:trackpocket/utiles/const.dart';
import 'package:trackpocket/models/transaction_model.dart';
import 'package:trackpocket/providers/theme_provider.dart';
import 'package:trackpocket/providers/transaction_provider.dart';
import 'package:trackpocket/widgets/app_dropdown_field.dart';
import 'package:trackpocket/widgets/app_text_field.dart';
import 'package:trackpocket/widgets/custom_loader.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit(TransactionProvider provider) async {
    if (_formKey.currentState!.validate()) {
      provider.isLoadingListen(true);
      final newTx = TransactionModel(
        id: const Uuid().v4(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: provider.selectedCategory,
        date: provider.selectedDate,
        isIncome: provider.isIncome,
      );

      await provider.addTransaction(newTx);
      if (provider.selectedCategory != "Salary") {
        await Provider.of<BudgetProvider>(
          context,
          listen: false,
        ).checkLimitExceeded(provider.transactions);
      }

      Provider.of<TransactionProvider>(context, listen: false).selectedDate =
          DateTime.now();
      provider.isLoadingListen(false);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeProvider>();
    final isDark = themeState.isDarkMode;

    return Scaffold(
      backgroundColor: whiteColor,
      body: Form(
        key: _formKey,
        child: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Category Dropdown
                  AppDropDownField(
                    value: provider.selectedCategory,
                    items: provider.categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (value) =>
                        provider.categoryDropDownListen(value),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  AppTextFormField(
                    title: "Name",
                    maxLength: 20,
                    controller: _titleController,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter name" : null,
                  ),

                  const SizedBox(height: 20),

                  // Amount
                  AppTextFormField(
                    title: "Amount",
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [allowNumberOnly],
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Enter amount";
                      final num = double.tryParse(v);
                      return (num == null || num <= 0)
                          ? "Enter valid number"
                          : null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Date Picker
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date: ${provider.selectedDate.toLocal().toString().split(' ')[0]}",
                          style: TextStyle(color: chrome900, fontSize: 14),
                        ),
                        TextButton.icon(
                          onPressed: () => provider.pickDate(context),
                          icon: const Icon(
                            Icons.calendar_month,
                            color: chrome900,
                          ),
                          label: const Text("Pick Date"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Income / Expense Switch
                  SwitchListTile(
                    value: provider.isIncome,
                    title: const Text("Is Income?"),
                    onChanged: provider.switchListTileFun,
                    activeThumbColor: mainColor,
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: screenWidth(context),
                    height: 50,
                    child: provider.isLoading
                        ? CustomLoader()
                        : ElevatedButton.icon(
                            onPressed: () => _submit(provider),
                            icon: Icon(Icons.add, color: whiteColor),
                            label: const Text(
                              "Add Transaction",
                              style: TextStyle(color: whiteColor, fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? chrome900 : mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
