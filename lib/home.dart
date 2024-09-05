import 'package:flutter/material.dart';
import 'login.dart'; // Import the login screen
import 'new_member.dart'; // Import the new member screen
import 'monthly_payment.dart'; // Import the monthly payment screen
import 'all_members.dart';
import 'paid_members.dart';
import 'unpaid_members.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Update the background color to match the dark theme
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0,
        title: const Text('Administrator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: false,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white54,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded Logout button
                ),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home1.jpg'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Column(
            children: [
              const SizedBox(height: 20),
              // Logo
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/logo.jpg'), // Replace with your logo path
                ),
              ),
              const SizedBox(height: 30),
              // Buttons
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        icon: Icons.person_add,
                        text: 'New Member',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewMemberScreen()),
                          );
                        },
                      ),
                      CustomButton(
                        icon: Icons.payment,
                        text: 'Monthly Payment',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MonthlyPaymentScreen()),
                          );
                        },
                      ),
                      CustomButton(
                        icon: Icons.group,
                        text: 'All Members',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllMembers()),
                          );
                        },
                        ),
                       CustomButton(
                          icon: Icons.check_box,
                          text: 'Paid Members',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaidMembers()),
                          );
                        },
                      ),
                       CustomButton(
                          icon: Icons.check_box_outline_blank,
                          text: 'Un-Paid Members',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UnpaidMembers()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed; // Accepts an optional onPressed callback

  const CustomButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed, // Constructor parameter for onPressed callback
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed, // Assign onPressed callback to the button
        icon: Icon(icon, color: Colors.white), // Icon color updated to white
        label: Text(
          text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Text color updated to white
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white12, // Button color updated to purple
          padding: const EdgeInsets.symmetric(vertical: 20), // Increased padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded buttons
          ),
        ),
      ),
    );
  }
}
