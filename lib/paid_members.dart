import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class PaidMembers extends StatelessWidget {
  const PaidMembers({super.key}); // Corrected constructor

  // Get the current month and year
  int getCurrentMonth() {
    return DateTime.now().month;
  }

  int getCurrentYear() {
    return DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
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
                // Members List
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('members').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No members found.'));
                      }

                      final currentMonth = getCurrentMonth();
                      final currentYear = getCurrentYear();

                      // Filter members whose payment month is equal to the current month
                      final members = snapshot.data!.docs.where((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        Timestamp? timestamp = data['timestamp'] as Timestamp?;

                        if (timestamp != null) {
                          DateTime date = timestamp.toDate();
                          return date.month == currentMonth && date.year == currentYear;
                        }
                        return false;
                      }).toList();

                      if (members.isEmpty) {
                        return const Center(child: Text('No members found for the current month.'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          var memberData = members[index].data() as Map<String, dynamic>;
                          return MemberCard(
                            name: '${memberData['firstName']} ${memberData['lastName']}',
                            nic: memberData['nic'],
                          );
                        },
                      );
                    },
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
  final String name;
  final String nic;

  const MemberCard({super.key, required this.name, required this.nic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), // Slight transparency
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name field
          Text(
            "Name: $name",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          // NIC field
          Text(
            "NIC: $nic",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
