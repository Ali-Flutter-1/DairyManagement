import 'package:dairyapp/CustomWidets/custom_inner_text_field.dart';
import 'package:dairyapp/Firebase/employee_service.dart';
import 'package:flutter/material.dart';
import '../../CustomWidets/custom_toast.dart';


class EmployeeDescriptionScreen extends StatefulWidget {
  const EmployeeDescriptionScreen({super.key});

  @override
  State<EmployeeDescriptionScreen> createState() =>
      _EmployeeDescriptionScreenState();
}

class _EmployeeDescriptionScreenState extends State<EmployeeDescriptionScreen> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _salaryController = TextEditingController();

  bool _isLoading=false;


  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _salaryController.dispose();

    super.dispose();
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
          "New Employee Entry",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Font1',
            color:  const Color(0xFF7CB342),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:   Color(0xFF7CB342),
                    child: Icon(Icons.people, color: Colors.white, size: 30),
                  ),
                ),
              ),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'New Employee Entry',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Add and manage employee records',
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
                      CustomInnerInputField(
                        label: 'Employee Name',
                        controller: _nameController,

                        keyboardType: TextInputType.name
                      ),
                      const SizedBox(height: 16),
                      CustomInnerInputField(
                        label: 'Employee Salary',
                        controller: _salaryController,

                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 16),
                      CustomInnerInputField(
                        label: 'Phone Number',
                        controller: _phoneNumberController,

                        maxLines: 1,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                            final employeeName =
                            _nameController.text.trim();
                            final employeeSalary =
                            _salaryController.text.trim();
                            final employeePhone =
                            _phoneNumberController.text.trim();

                            if (employeeName.isEmpty ||
                                employeeSalary.isEmpty) {
                              showCustomToast(context,
                                  "Please enter the required information",isError: true);
                              return;
                            }

                            // ✅ Phone number validation only if not empty
                            if (employeePhone.isNotEmpty &&
                                (employeePhone.length != 11 ||
                                    int.tryParse(employeePhone) == null)) {
                              showCustomToast(context,
                                  "Phone number must be 11 digits",isError: true);
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              await EmployeeService().addEmployee(
                                name: employeeName,
                                salary: double.tryParse(employeeSalary) ??
                                    0.0,
                                phone: employeePhone.isEmpty
                                    ? null
                                    : employeePhone,
                                context: context,
                              );

                              showCustomToast(context,
                                  "Employee data saved successfully");

                              _phoneNumberController.clear();
                              _salaryController.clear();
                              _nameController.clear();
                            } catch (e) {
                              showCustomToast(context,
                                  "Error saving employee: $e",isError: true);
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  const Color(0xFF7CB342),
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
