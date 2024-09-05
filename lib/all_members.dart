import 'package:flutter/material.dart';

class AllMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
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
                SizedBox(height: 20), // Space at the top
                // Logo Section
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo.jpg'), // Replace with your logo path
                  ),
                ),
                SizedBox(height: 10),
                // "All Members" text
                Text(
                  "All Members",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // NIC Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // NIC Input Field
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Enter NIC',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Search Button
                      ElevatedButton(
                        onPressed: () {
                          // Search logic can go here
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15), backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ), // Button background color
                        ),
                        child: Text('Search'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Members List
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      MemberDetailsCard(),
                      SizedBox(height: 10),
                      MemberDetailsCard(),
                      SizedBox(height: 10),
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

class MemberDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Slight transparency
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Member Details fields
          buildMemberDetailText("First Name :"),
          buildMemberDetailText("Last Name :"),
          buildMemberDetailText("NIC :"),
          buildMemberDetailText("Contact Number :"),
          buildMemberDetailText("Address :"),
          buildMemberDetailText("Last Paid Month :"),
          buildMemberDetailText("Emg Name :"),
          buildMemberDetailText("Emg Contact :"),
        ],
      ),
    );
  }

  Widget buildMemberDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
