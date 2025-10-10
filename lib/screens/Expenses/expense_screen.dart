import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyapp/screens/Expenses/expense_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Firebase/expense_service.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String selectedPeriod = "Week";
  String selectedThing = "Others";
  final ExpenseService _expenseService = ExpenseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Expenses",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Font1'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Total Expense Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _expenseService.getExpensesStream(),
                builder: (context, snapshot) {
                  double total = 0;

                  if (snapshot.hasData) {
                    final expenses = snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final timestamp = data['createdAt'] as Timestamp?;
                      if (timestamp == null) return false;

                      final date = timestamp.toDate();
                      return _filterByPeriod(date);
                    }).toList();

                    for (var doc in expenses) {
                      total += (doc['amount'] as num).toDouble();
                    }
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF7CB342),
                            child: Icon(Icons.money_off, color: Colors.white),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Expense ($selectedPeriod)',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Font',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rs ${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Font1',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // 🟡 Period Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Time Period:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Font',
                      fontSize: 18),
                ),
                const SizedBox(width: 10),
                _buildPeriodButton("Week"),
                const SizedBox(width: 8),
                _buildPeriodButton("Month"),
                const SizedBox(width: 8),
                _buildPeriodButton("All"),
              ],
            ),

            const SizedBox(height: 20),

            // 🟢 Category Tabs
            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildTabButton("Medicine"),
                    const SizedBox(width: 10),
                    _buildTabButton("Equipment"),
                    const SizedBox(width: 8),
                    _buildTabButton("Utilities"),
                    const SizedBox(width: 8),
                    _buildTabButton("Others"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🟣 Expense List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _expenseService.getExpensesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyExpenseView();
                  }

                  final filteredExpenses = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final category = data['category'];
                    final timestamp = data['createdAt'] as Timestamp?;
                    if (timestamp == null) return false;

                    final date = timestamp.toDate();
                    return category == selectedThing && _filterByPeriod(date);
                  }).toList();

                  if (filteredExpenses.isEmpty) {
                    return _buildEmptyExpenseView();
                  }

                  return  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final data = filteredExpenses[index].data() as Map<String, dynamic>;
                      final createdAt = data['createdAt'] as Timestamp?;
                      final date = createdAt?.toDate();
                      final formattedDate =
                      date != null ? DateFormat('dd MMM yyyy').format(date) : '—';
                      final amount = (data['amount'] ?? 0).toDouble();

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFE8F5E9), // very light green
                              Color(0xFFB9F6CA),  // near white green tint
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF7CB342),
                                  Color(0xFF9CCC65),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.money_rounded, color: Colors.white, size: 24),
                            ),
                          ),
                          title: Text(
                            data['description'] ?? 'No Description',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                              fontFamily: 'Font1',
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "📂 Category: ${data['category'] ?? 'Unknown'}",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                Text(
                                  "💰 Amount: Rs ${amount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF33691E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: 'add_expense',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ExpenseDescriptionScreen()),
          );
        },
        backgroundColor: const Color(0xFF7CB342),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  Widget _buildPeriodButton(String label) {
    final isSelected = selectedPeriod == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7CB342) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final isSelected = selectedThing == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedThing = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlueAccent.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.lightBlue.shade200
                : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyExpenseView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.money_off, color: Color(0xFF7CB342), size: 60),
          const SizedBox(height: 16),
          const Text(
            "No Expense Recorded",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Font2',
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Start by adding your first expense",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExpenseDescriptionScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CB342),
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Add Expense",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  bool _filterByPeriod(DateTime date) {
    final now = DateTime.now();
    if (selectedPeriod == "Week") {
      final weekAgo = now.subtract(const Duration(days: 7));
      return date.isAfter(weekAgo);
    } else if (selectedPeriod == "Month") {
      return date.month == now.month && date.year == now.year;
    } else {
      return true; // All
    }
  }
}
