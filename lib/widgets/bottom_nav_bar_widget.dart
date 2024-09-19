import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  final Function(int) onItemSelected; // Callback to notify parent
  final int currentIndex; // Current selected index

  const BottomNavBarWidget({
    super.key,
    required this.onItemSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department),
          label: 'Calorie Data',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate),
          label: 'BMI',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.nights_stay),
          label: 'Sleep',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.opacity),
          label: 'Water',
        ),
      ],
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      // To animate the selection, you can use the `BottomNavigationBar`'s properties
    );
  }
}
