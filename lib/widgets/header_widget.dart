import 'package:flutter/material.dart';
import 'package:health/pages/profile_page.dart'; // Import ProfilePage

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Align remaining elements to the end
      children: [
        InkWell(
          onTap: () {
            // Navigate to ProfilePage on tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          child: Container(
            width: 40.0, // Adjust the size as needed
            height: 40.0, // Adjust the size as needed
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 2), // Border color and width
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  "assets/images/avatar.png",
                  width: 32, // Ensure image fits within the CircleAvatar
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
