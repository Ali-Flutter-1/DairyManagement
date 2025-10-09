import 'package:dairyapp/Firebase/employee_service.dart';
import 'package:flutter/material.dart';


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
      backgroundColor: Colors.grey.shade200,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:  const Color(0xFF7CB342),
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
                      _buildInputField(
                        label: 'Employee Name',
                        controller: _nameController,

                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        label: 'Employee Salary',
                        controller: _salaryController,

                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 16),
                      _buildInputField(
                        label: 'Phone Number',
                        controller: _phoneNumberController,

                        maxLines: 1,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            String employeeName = _nameController.text.trim();
                            String employeeSalary = _salaryController.text.trim();
                            String employeePhone = _phoneNumberController.text.trim();



                            if (employeeName.isEmpty ||
                                employeeSalary.isEmpty ||
                                employeePhone.isEmpty
                                ) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(" Please enter all required information")),
                              );
                              return;
                            }


                            if (employeePhone.length != 11 || int.tryParse(employeePhone) == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(" Phone number must be 11 digits")),
                              );
                              return;
                            }


                            try {
                              await EmployeeService().addEmployee(
                               name: employeeName,
                                salary: double.tryParse(_salaryController.text) ?? 0.0,
                                phone: employeePhone,
                                  context: context
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Employee data saved successfully")),
                              );


                              _phoneNumberController.clear();
                              _salaryController.clear();
                              _nameController.clear();
                            } catch (e) {
                              print(e.toString());
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
                          child: const Text(
                            'Save Entry',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _buildInputField({
    required String label,
    TextEditingController? controller,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          validator: (value) {
            if (!readOnly && (value?.isEmpty ?? true)) {
              return 'Please enter $label';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.grey[400])
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4CAF50)),
            ),
            contentPadding: const EdgeInsets.all(16.0),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
