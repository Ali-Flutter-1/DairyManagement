import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Font1'),
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
                  SizedBox(height: 5,),
              Text(
                'Rana Dairy Farm',
                style:TextStyle(
                  fontWeight: FontWeight.bold,fontFamily: 'Font',fontSize: 24
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.grey,fontFamily: 'Font2',fontSize: 14,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
        
              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Font'
                ),
              ),
              const SizedBox(height: 15),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _QuickActionButton(
                    color: Color(0xFF7CB342),
                    icon: Icons.local_drink,
                    label: 'Add Milk',
                  ),
                  _QuickActionButton(
                    color: Color(0xFFD7CCC8),
                    icon: Icons.person_add,
                    label: 'Add Employee',
                  ),
                  _QuickActionButton(
                    color: Color(0xFFE57373),
                    icon: Icons.receipt_long,
                    label: 'Add Expense',
                  ),
                ],
              ),
              const SizedBox(height: 30),
        
              // Info Cards
              const _InfoCard(
                icon: Icons.local_drink,
                title: "Today's Milk",
                value: '0 L',
              ),
              const _InfoCard(
                icon: Icons.attach_money,
                title: 'Monthly Income',
                value: '20',
              ),
              const _InfoCard(
                icon: Icons.receipt_long,
                title: 'Monthly Expenses',
                value: '40',
              ),
              const _InfoCard(
                icon: Icons.trending_up,
                title: 'Monthly Profit',
                value: '100',
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _QuickActionButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;

  const _QuickActionButton({
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
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
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 26),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
