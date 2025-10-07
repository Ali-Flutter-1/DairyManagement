import 'package:dairyapp/screens/Dashboard/dashboard_screen.dart';
import 'package:dairyapp/screens/Milk/milk_screen.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int myIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    MilkScreen(),
    Center(child: Text('Employees')),
    Center(child: Text('Expenses')),
    Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.green.withOpacity(0.15),
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (states) => TextStyle(
              fontWeight: FontWeight.w600,
              color: states.contains(MaterialState.selected)
                  ? Colors.green
                  : Colors.grey,
            ),
          ),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
                (states) => IconThemeData(
              color: states.contains(MaterialState.selected)
                  ? Colors.green
                  : Colors.grey,
            ),
          ),
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: myIndex,
          onDestinationSelected: (index) {
            setState(() => myIndex = index);
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.dashboard),
              icon: Icon(Icons.dashboard_outlined),
              label: 'Dashboard',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.opacity),
              icon: Icon(Icons.opacity_outlined),
              label: 'Milk',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.people),
              icon: Icon(Icons.people_alt_outlined),
              label: 'Employee',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.money_off),
              icon: Icon(Icons.money_off_csred_outlined),
              label: 'Expenses',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
