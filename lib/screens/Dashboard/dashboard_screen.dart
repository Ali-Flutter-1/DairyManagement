import 'package:dairyapp/Provider/expense_provider.dart';
import 'package:dairyapp/Provider/milk_provider.dart';
import 'package:dairyapp/Provider/salary_provider.dart';
import 'package:dairyapp/screens/Employees/employee_description_screen.dart';
import 'package:dairyapp/screens/Expenses/expense_description_screen.dart';
import 'package:dairyapp/screens/Milk/milk_description_screen.dart';
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
    final double totalMorningLiter = milkProvider.todayMorningLitres;
    final double totalEveningLiter = milkProvider.totalEveningLitres;
    final double totalSalary = salaryProvider.totalSalaries;

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
      backgroundColor: Colors.grey.shade200,
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
              // Dashboard Cards
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
                value: 'Rs ${monthlyExpense.toStringAsFixed(2)}',
              ),
              _InfoCard(
                icon: Icons.trending_up,
                title: 'Monthly Profit',
                value: getMonthlyProfitText(),
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
