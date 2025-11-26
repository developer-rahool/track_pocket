import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackpocket/providers/theme_provider.dart';
import 'package:trackpocket/theme/app_theme.dart';
import 'package:trackpocket/widgets/app_dropdown_field.dart';
import 'package:trackpocket/providers/transaction_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trackpocket/utiles/const.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({super.key});

  @override
  State<StaticsScreen> createState() => _StaticsScreenState();
}

class _StaticsScreenState extends State<StaticsScreen> {
  late TransactionProvider txProvider;
  late ThemeProvider themeState;

  final List<Color> barColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    txProvider = context.read<TransactionProvider>();
    themeState = context.read<ThemeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          /// Let provider calculate totals (not inside build)
          final totals = provider.calculateStaticsTotals();
          final keys = totals.keys.toList();

          final barGroups = List.generate(keys.length, (i) {
            final category = keys[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: totals[category]!,
                  color: barColors[i % barColors.length],
                  width: 22,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          });

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),

                /// FILTER DROPDOWN
                AppDropDownField(
                  value: provider.filterStaticsName,
                  items: provider.filterStaticsNameCategory
                      .map(
                        (range) =>
                            DropdownMenuItem(value: range, child: Text(range)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.onStaticsFilterChanged(value);
                    }
                  },
                ),

                const SizedBox(height: 20),

                /// CHART SECTION
                Expanded(
                  child: totals.isEmpty
                      ? Center(
                          child: Text(
                            'No transactions added yet.',
                            style: TextStyle(
                              color: theme.isDarkMode ? whiteColor : mainColor,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: _maxValue(totals) + 20,

                              /// Touch tooltip
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                        final category = keys[group.x.toInt()];

                                        return BarTooltipItem(
                                          "$category\n\$${rod.toY.toStringAsFixed(2)}",
                                          const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                ),
                              ),

                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (_, __) =>
                                        const SizedBox.shrink(),
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: (_maxValue(totals) / 3),
                                    reservedSize: 32,
                                    getTitlesWidget: (value, _) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                          color: theme.isDarkMode
                                              ? whiteColor
                                              : chrome900,
                                          fontSize: 15,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),

                              borderData: FlBorderData(show: false),
                              barGroups: barGroups,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Find max bar value for smooth chart UI
  double _maxValue(Map<String, double> map) {
    if (map.isEmpty) return 100;
    return map.values.reduce((a, b) => a > b ? a : b);
  }
}
