import 'package:dairyapp/Provider/expense_provider.dart';
import 'package:dairyapp/Provider/milk_provider.dart';
import 'package:dairyapp/Provider/salary_provider.dart';
import 'package:dairyapp/screens/Employees/employee_description_screen.dart';
import 'package:dairyapp/screens/Expenses/expense_description_screen.dart';
import 'package:dairyapp/screens/Milk/milk_description_screen.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Firebase/milk_service.dart';
import '../../Model/milk_model.dart';
import '../../Provider/provider_userdata.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final milkProvider = Provider.of<MilkProvider>(context);
    final salaryProvider = Provider.of<EmployeeSalaryProvider>(context);

    final double monthlyExpense = expenseProvider.monthlyExpense;
    final double monthlyIncome = milkProvider.monthlyRevenue;
    final double todayRevenue = milkProvider.todayRevenue;
    final double todayLiter = milkProvider.totalLitres;
    final double totalMorningLiter = milkProvider.totalMorningLitres;
    final double totalEveningLiter = milkProvider.totalEveningLitres;
    final double totalSalary = salaryProvider.totalSalaries;
    final double totalExpense=monthlyExpense+totalSalary;
    final date = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    String getMonthlyProfitText() {
      final totalProfit = monthlyIncome - (monthlyExpense + totalSalary);
      return totalProfit > 0
          ? totalProfit.toStringAsFixed(2)
          : '-${totalProfit.abs().toStringAsFixed(2)}';
    }

    Color getMonthlyProfitColor() {
      final totalProfit = monthlyIncome - (monthlyExpense + totalSalary);
      if (totalProfit > 0) return Colors.green;
      if (totalProfit < 0) return Colors.red;
      return Colors.grey;
    }



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Font1'),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Owner & Date
              Consumer<FarmProvider>(
                builder: (context, provider, child) {
                  return Text(
                    provider.ownerName.isNotEmpty
                        ? provider.ownerName
                        : 'Owner Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),

              Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Font2',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Font',
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _QuickActionButton(
                    color: const Color(0xFF7CB342),
                    icon: Icons.local_drink,
                    label: 'Add Milk',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MilkDescriptionScreen(),
                        ),
                      );
                    },
                  ),
                  _QuickActionButton(
                    color: const Color(0xFFD7CCC8),
                    icon: Icons.person_add,
                    label: 'Add Employee',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployeeDescriptionScreen(),
                        ),
                      );
                    },
                  ),
                  _QuickActionButton(
                    color: const Color(0xFFE57373),
                    icon: Icons.receipt_long,
                    label: 'Add Expense',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExpenseDescriptionScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Morning & Evening Milk Info
              buildLiterInfo(context, totalMorningLiter, totalEveningLiter),


              const SizedBox(height: 10),
              revenueExpenseLineChart(context),
              const SizedBox(height: 20),



              _InfoCard(
                icon: Icons.local_drink,
                title: "Today's Litres",
                value: '${todayLiter.toStringAsFixed(2)} L',
              ),
              _InfoCard(
                icon: Icons.attach_money,
                title: "Today's Revenue",
                value: 'Rs ${todayRevenue.toStringAsFixed(2)}',
              ),
              _InfoCard(
                icon: Icons.attach_money,
                title: 'Monthly Income',
                value: 'Rs ${monthlyIncome.toStringAsFixed(2)}',
              ),
              _InfoCard(
                icon: Icons.receipt_long,
                title: 'Monthly Expenses',
                value: 'Rs ${totalExpense.toStringAsFixed(2)}',
                valueColor: Colors.red, // 🔴 Expense value in red
              ),
              _InfoCard(
                icon: Icons.trending_up,
                title: 'Monthly Profit',
                value: 'Rs ${getMonthlyProfitText()}', // 💰 Added Rs before profit
                valueColor: getMonthlyProfitColor(),
              ),


              const SizedBox(height: 20),
              // Recent Milk Entries Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Milk Entries',
                    style: TextStyle(
                      fontFamily: 'Font',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MilkDescriptionScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFF7CB342),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              recentMilkEntries(context),
            ],
          ),
        ),
      ),
    );
  }
  Widget revenueExpenseLineChart(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final milkProvider = Provider.of<MilkProvider>(context);
    final salaryProvider = Provider.of<EmployeeSalaryProvider>(context);

    // Use your real maps for daily data
    final Map<DateTime, double> expenseMap = expenseProvider.dailyExpenses;
    final Map<String, double> salaryMap = salaryProvider.dailySalaryData;
    final Map<DateTime, double> milkMap = milkProvider.dailyRevenue.cast<DateTime, double>();

    // Convert salaryMap keys (String) to DateTime for merging
    final salaryDateMap = <DateTime, double>{};
    for (var entry in salaryMap.entries) {
      final parsedDate = DateTime.tryParse(entry.key);
      if (parsedDate != null) salaryDateMap[parsedDate] = entry.value;
    }

    // Combine all unique dates
    final allDates = <DateTime>{
      ...milkMap.keys,
      ...expenseMap.keys,
      ...salaryDateMap.keys,
    }.toList()
      ..sort();

    if (allDates.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    // Find the maximum value for better scaling
    double maxValue = 0;
    for (final date in allDates) {
      final revenue = milkMap[date] ?? 0;
      final expense = (expenseMap[date] ?? 0) + (salaryDateMap[date] ?? 0);
      maxValue = maxValue > revenue ? maxValue : revenue;
      maxValue = maxValue > expense ? maxValue : expense;
    }

    // Build bar groups
    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < allDates.length; i++) {
      final date = allDates[i];
      final revenue = milkMap[date] ?? 0;
      final expense = (expenseMap[date] ?? 0) + (salaryDateMap[date] ?? 0);

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: revenue,
              color: Colors.green,
              width: 14,
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            BarChartRodData(
              toY: expense,
              color: Colors.redAccent,
              width: 14,
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.redAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ],
        ),
      );
    }

    // Function to format Y-axis labels
    String formatYAxisValue(double value) {
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M';
      } else if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(0)}k';
      } else {
        return value.toInt().toString();
      }
    }

    // Chart UI
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue / 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                interval: maxValue / 5,
                getTitlesWidget: (value, meta) => Text(
                  formatYAxisValue(value),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < allDates.length) {
                    final date = allDates[value.toInt()];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "${date.day}/${date.month}",
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.black87,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final date = allDates[group.x.toInt()];
                final label = rodIndex == 0 ? "Revenue" : "Expense";
                return BarTooltipItem(
                  "$label\n${date.day}/${date.month}/${date.year}\nRs ${rod.toY.toStringAsFixed(1)}",
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              if (event is FlTapUpEvent && barTouchResponse != null && barTouchResponse.spot != null) {
                final touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                if (touchedIndex >= 0 && touchedIndex < allDates.length) {
                  final selectedDate = allDates[touchedIndex];
                  // You can add code here to fetch detailed data for the selected date
                  // For example, show a dialog or navigate to a details screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Selected date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              }
            },
          ),
          maxY: maxValue * 1.1, // Add 10% padding to the top
        ),
      ),
    );
  }

  Widget buildLiterInfo(BuildContext context, double morning, double evening) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.wb_sunny, color: Colors.yellow, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Morning Milk',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        morning.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: Icon(
                      Icons.nightlight_round,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Evening Milk',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        evening.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget recentMilkEntries(BuildContext context) {
    return StreamBuilder<List<MilkSale>>(
      stream: MilkService().getAllMilkSales(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No sales recorded',
              style: TextStyle(color: Colors.black,fontFamily: 'Font',fontWeight: FontWeight.bold,fontSize: 16),
            ),
          );
        }

        final sales = snapshot.data!;
        sales.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // ✅ Only show 5 most recent
        final recentSales = sales.take(5).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentSales.length,
          itemBuilder: (context, index) {
            final sale = recentSales[index];
            final totalLiters = sale.morningQuantity + sale.eveningQuantity;
            final totalPrice = totalLiters * sale.pricePerLitre;
            final formattedDate = DateFormat('dd MMM yyyy').format(sale.date);

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),

                   color:  Colors.white,






                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_drink, color: Color(0xFF7CB342)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sale.customer,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Rs ${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.wb_sunny,
                              color: Colors.yellow,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${sale.morningQuantity} L",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.nightlight_round,
                              color: Colors.blueAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${sale.eveningQuantity} L",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Date: $formattedDate",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Price/Litre: Rs ${sale.pricePerLitre}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickActionButton({
    required this.color,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 36,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF7CB342), size: 26),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}
