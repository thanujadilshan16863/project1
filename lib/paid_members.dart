import 'package:flutter/material.dart';

class PaidMembers extends StatelessWidget {
  const PaidMembers({super.key}); // Corrected constructor

  @override
  Widget build(BuildContext context) { // Removed the incorrect createState method
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home1.jpg'), // Path to your background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Space at the top
                // Logo Section
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo.jpg'), // Replace with your logo path
                  ),
                ),
                const SizedBox(height: 10),
                // "Paid Members" text
                const Text(
                  "Paid Members",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Members Form List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: const [
                      MemberCard(),
                      SizedBox(height: 10),
                      MemberCard(),
                      SizedBox(height: 10),
                      MemberCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  const MemberCard({super.key}); // Added const and key to the constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Slight transparency
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name field
          Text(
            "Name :",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter member name',
            ),
          ),
          SizedBox(height: 10),
          // NIC field
          Text(
            "NIC :",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter NIC number',
            ),
          ),
        ],
      ),
    );
  }
}
