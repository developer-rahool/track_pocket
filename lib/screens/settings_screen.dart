import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackpocket/notifications/budget_storage_helper.dart';
import 'package:trackpocket/providers/budget_provider.dart';
import 'package:trackpocket/providers/transaction_provider.dart';
import 'package:trackpocket/theme/app_theme.dart';
import 'package:trackpocket/utiles/const.dart';
import 'package:trackpocket/widgets/app_text_field.dart';
import 'package:trackpocket/widgets/customAlertDialog.dart';
import 'package:trackpocket/widgets/custom_loader.dart';
import 'package:trackpocket/widgets/show_snackbar.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ThemeProvider themeState = ThemeProvider();
  BudgetProvider bxProvider = BudgetProvider();
  @override
  void initState() {
    themeState = context.read<ThemeProvider>();
    bxProvider = context.read<BudgetProvider>();
    bxProvider.loadBudget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Consumer<BudgetProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                SizedBox(height: 60),
                SwitchListTile(
                  activeThumbColor: Theme.of(context).primaryColor,
                  title: const Text("Dark Mode"),
                  value: themeState.isDarkMode,
                  onChanged: (_) => themeState.toggleTheme(),
                ),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 20),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenWidth(context),
                        child: AppTextFormField(
                          title: "Enter budget amount",
                          controller: provider.budgetController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [allowNumberOnly],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter budget amount";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _filterButton(
                            title: "Daily",
                            active: provider.dailyButtonTap,
                            darkMode: themeState.isDarkMode,
                            onTap: () {
                              provider.dailyButtonTapListen();
                            },
                          ),
                          const SizedBox(width: 10),
                          _filterButton(
                            title: "Weekly",
                            active: provider.weeklyButtonTap,
                            darkMode: themeState.isDarkMode,
                            onTap: () {
                              provider.weeklyButtonTapListen();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: screenWidth(context),
                  height: 50,
                  child: provider.isLoading
                      ? CustomLoader()
                      : ElevatedButton.icon(
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              provider.isLoadingListen(true);
                              if (provider.budgetControllerText == "") {
                                await BudgetStorage.saveBudget(
                                  provider.budgetController.text,
                                  provider.limitMode,
                                );
                                bxProvider.loadBudget();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => CustomAlertDialogWidget(
                                    onActionPressed: () async {
                                      Navigator.pop(context);
                                      await BudgetStorage.removeBudget(
                                        "budget_value",
                                      );
                                      await BudgetStorage.removeBudget(
                                        "budget_mode",
                                      );
                                      provider.budgetControllerTextUpdate("");

                                      provider.budgetController.clear();
                                      provider.dailyButtonTapListen();
                                      ShowCustomSnackBar(
                                        msg: "Budget Reminder Delete",
                                      );
                                    },
                                    title: "Budget Reminder",
                                    desciption:
                                        "Are you Sure! you want to Delete Budget?",
                                  ),
                                );
                              }
                              provider.isLoadingListen(false);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: themeState.isDarkMode
                                ? WidgetStateProperty.all(chrome900)
                                : WidgetStateProperty.all(mainColor),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.notifications,
                            color: provider.budgetControllerText == ""
                                ? whiteColor
                                : Colors.red,
                            size: 24,
                          ),
                          label: Text(
                            provider.budgetControllerText == ""
                                ? "Set Budget Reminder"
                                : "Remove Budget Reminder",
                            style: TextStyle(
                              color: provider.budgetControllerText == ""
                                  ? whiteColor
                                  : Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: screenWidth(context),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (_) => CustomAlertDialogWidget(
                          onActionPressed: () {
                            Provider.of<TransactionProvider>(
                              context,
                              listen: false,
                            ).clearAllTransactions();
                            Navigator.pop(context);
                            ShowCustomSnackBar(msg: "All transactions cleared");
                          },
                          title: "Delete",
                          desciption: "Are you Sure! you want to Delete All?",
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: themeState.isDarkMode
                          ? WidgetStateProperty.all(Colors.black)
                          : WidgetStateProperty.all(mainColor),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.delete, color: Colors.red, size: 24),
                    label: const Text(
                      "Clear Data",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _filterButton({
    required String title,
    required bool active,
    required bool darkMode,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 95,
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
}
