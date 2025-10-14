import 'package:dairyapp/CustomWidets/custom_inner_text_field.dart';
import 'package:dairyapp/Firebase/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../CustomWidets/custom_toast.dart';
import '../../Provider/category_provider.dart';


class ExpenseDescriptionScreen extends StatefulWidget {
  const ExpenseDescriptionScreen({super.key});

  @override
  State<ExpenseDescriptionScreen> createState() =>
      _ExpenseDescriptionScreenState();
}

class _ExpenseDescriptionScreenState extends State<ExpenseDescriptionScreen> {
  final _expenseController = TextEditingController();

  final _priceController = TextEditingController();

  final _descriptionController = TextEditingController();



  String? _selectedExpense;
bool _isLoading=false;


  @override
  void dispose() {
    _expenseController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _saveExpense() async {
    String? expenseCatogary = _selectedExpense;
    String amountText = _priceController.text.trim();
    String description = _descriptionController.text.trim();
    if (expenseCatogary == null || expenseCatogary.isEmpty) {
      showCustomToast(context, "Please Select an expense category",isError: true);
      return;
    }
    if (amountText.isEmpty ) {
      showCustomToast(context, "Please Enter the amount",isError: true);
      return;
    }

    double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      showCustomToast(context, "Enter a valid Amount",isError: true);
      return;
    }
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      await ExpenseService().addExpense(
        category: expenseCatogary,
        amount: amount,

        description: description.isEmpty?null:description,

      );

      showCustomToast(context, "Expense Added Successfully");
      Navigator.pop(context);
    } catch (e) {
      showCustomToast(context, "Error :$e",isError: true);
    }
    finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: const Color(0xFF4CAF50),
          ),
        ),
        title: Text(
          "New Expense Entry",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Font1',
            color: const Color(0xFF7CB342),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:  Color(0xFF7CB342),
                    child: Icon(Icons.money_off, color: Colors.white, size: 30),
                  ),
                ),
              ),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'New Expense Entry',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track expenses for your dairy operations',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1), // soft grey shadow
                      blurRadius: 8, // how soft the shadow looks
                      spreadRadius: 2, // how far it spreads
                      offset: const Offset(0, 3), // slightly below the container
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 16),
                      Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, _) {

                          final categories = [...categoryProvider.categories];

                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Name of Expense',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value:_selectedExpense ,
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedExpense = value!;
                              });
                            },
                          );
                        },
                      ),


                      const SizedBox(height: 16),
                      CustomInnerInputField(
                        label: 'Amount',
                        controller: _priceController,

                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      CustomInnerInputField(
                        label: 'Description',
                        controller: _descriptionController,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ?null:_saveExpense,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7CB342),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                            'Save Entry',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                              Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.white,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Color(0xFF7CB342)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
