import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyapp/Firebase/employee_service.dart';
import 'package:dairyapp/screens/Employees/employee_description_screen.dart';
import 'package:flutter/material.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final EmployeeService _firestoreService = EmployeeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Employees",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Font1'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getEmployees(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              // 🔹 No employees yet
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people,
                        color: Color(0xFF7CB342), size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      "No Employee Added",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Font2',
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                      child: Text(
                        "Add employees to manage your farm staff",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const EmployeeDescriptionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7CB342),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Add Employee",
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            final employees = snapshot.data!.docs;

            // 🔹 Show List of Employees
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final data = employees[index].data() as Map<String, dynamic>;
                final name = data['name'] ?? 'Unknown';
                final salary = data['salary']?.toString() ?? '0.0';
                final phone = data['phone'] ?? 'N/A';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.person, color: Colors.white, size: 26),
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                        fontFamily: 'Font',
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '💰 Salary: $salary\n📞 Phone: $phone',
                        style: const TextStyle(
                          color: Colors.black54,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Colors.redAccent, size: 26),
                      onPressed: () {
                        _firestoreService.deleteEmployee(employees[index].id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name deleted'),
                            backgroundColor: Colors.redAccent.shade200,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      // 🔹 Floating Add Button
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_employee',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmployeeDescriptionScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF7CB342),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
