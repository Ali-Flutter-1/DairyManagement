import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyapp/CustomWidets/custom_toast.dart';
import 'package:dairyapp/screens/Expenses/expense_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Firebase/expense_service.dart';
import '../../Provider/category_provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String selectedPeriod = "Week";
  String selectedThing = "Others";
  final ExpenseService _expenseService = ExpenseService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Expenses",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Font1'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap:() {
                _showAddCategoryDialog(context);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFF7CB342),
                ),
                child: Icon(Icons.add, size: 25, color: Colors.white),
              ),
            ),
          ),
        ],
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
                      vertical: 20,
                      horizontal: 24,
                    ),
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
                    fontSize: 18,
                  ),
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
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
                final categories = categoryProvider.categories;

                return SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final label = categories[index];
                      final isSelected = selectedThing == label;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFF9CCC65)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Color(0xFF9CCC65)
                                : Colors.grey.shade200,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  // if same category tapped again → reset to All
                                  if (selectedThing == label) {
                                    selectedThing = "All";
                                    showCustomToast(context, "Showing all expenses");
                                  } else {
                                    selectedThing = label;
                                  }
                                });
                              },
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),


                            const SizedBox(width: 6),

                            GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                          builder: (context, setStateDialog) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            backgroundColor: Colors.white,
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.warning_amber_rounded,
                                                  color: Colors.redAccent,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Delete Category",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: Text(
                                              "Are you sure you want to delete the '$label' category? This action cannot be undone.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pop(); // Close dialog
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: _isLoading
                                                    ? null
                                                    : () async {
                                                        setStateDialog(() {
                                                          _isLoading = true;
                                                        });

                                                        // 1. Delete all expenses under that category
                                                        await ExpenseService()
                                                            .deleteExpensesByCategory(
                                                              label,
                                                            );

                                                        // 2. Remove category from provider list
                                                        final categoryProvider =
                                                            Provider.of<
                                                              CategoryProvider
                                                            >(
                                                              context,
                                                              listen: false,
                                                            );
                                                        await categoryProvider
                                                            .removeCategory(
                                                              label,
                                                            );

                                                        // 3. Update selectedThing if needed
                                                        if (selectedThing ==
                                                            label) {
                                                          setState(() {
                                                            selectedThing =
                                                                'All'; // fallback
                                                          });
                                                        }

                                                        setStateDialog(() {
                                                          _isLoading = false;
                                                        });

                                                        Navigator.of(
                                                          context,
                                                        ).pop(); // Close dialog
                                                        showCustomToast(
                                                          context,
                                                          "Category deleted successfully",
                                                        );
                                                      },
                                                child: _isLoading
                                                    ? const SizedBox(
                                                        height: 24,
                                                        width: 24,
                                                        child:
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                              strokeWidth: 2,
                                                            ),
                                                      )
                                                    : Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                              child: Icon(
                                Icons.cancel,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
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

                    final categoryMatch = selectedThing == "All"
                        ? true
                        : category == selectedThing;

                    final periodMatch = selectedPeriod == "All"
                        ? true
                        : _filterByPeriod(date);

                    return categoryMatch && periodMatch;
                  }).toList();

                  if (filteredExpenses.isEmpty) {
                    return _buildEmptyExpenseView();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final data =
                          filteredExpenses[index].data()
                              as Map<String, dynamic>;
                      final createdAt = data['createdAt'] as Timestamp?;
                      final date = createdAt?.toDate();
                      final formattedDate = date != null
                          ? DateFormat('dd MMM yyyy').format(date)
                          : '—';
                      final amount = (data['amount'] ?? 0).toDouble();

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7CB342), Color(0xFF9CCC65)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.money_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          title: Text(
                            data['description'] ?? '',
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
                                    color: Colors.black87,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
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
          final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
          if(categoryProvider.categories.isEmpty){
            _showAddCategoryDialog(context);
          }
          else{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExpenseDescriptionScreen(),
              ),
            );
          }
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
              final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
              if(categoryProvider.categories.isEmpty){
                _showAddCategoryDialog(context);
              }
             else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenseDescriptionScreen(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CB342),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    bool _isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false, // prevent accidental close
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Add Expense Category",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Font1',
                        color: Color(0xFF33691E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        hintText: "Enter category name",
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(color: Color(0xFF7CB342), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white24,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                            final newCategory =
                            categoryController.text.trim();

                            if (newCategory.isEmpty) {
                              showCustomToast(context,
                                  "Please enter a category name");
                              return;
                            }

                            setStateDialog(() {
                              _isLoading = true;
                            });

                            try {
                              await categoryProvider
                                  .addCategory(newCategory);

                              showCustomToast(context,
                                  "Category added successfully");
                              Navigator.pop(context);
                            } catch (e) {
                              showCustomToast(
                                  context, "Error: ${e.toString()}");
                            } finally {
                              setStateDialog(() {
                                _isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7CB342),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Font1',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}
