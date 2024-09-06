import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UnpaidMembers extends StatelessWidget {
  const UnpaidMembers({super.key});

  // Get the current month and year
  int getCurrentMonth() {
    return DateTime.now().month;
  }

  int getCurrentYear() {
    return DateTime.now().year;
  }

  // Function to send SMS using Textit.biz API
  Future<void> sendSms(String phoneNumber, String message) async {
    final String apiKey = '94712958370';  // Replace with your Textit.biz API key
    final String senderId = '5199';    // Replace with your sender ID

    // Textit.biz API endpoint with query parameters for GET request
    final url = Uri.parse(
      'https://www.textit.biz/sendmsg?id=$apiKey&pw=$senderId&to=$phoneNumber&text=${Uri.encodeComponent(message)}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData['status'] == 'OK') {
        print('Message sent successfully to $phoneNumber');
      } else {
        print('Failed to send message to $phoneNumber: ${responseData['error']}');
      }
    } else {
      print('Failed to send SMS. Status code: ${response.statusCode}');
    }
  }

  // Function to send reminders to all unpaid members
  void sendReminderToUnpaidMembers(BuildContext context) async {
    final currentMonth = getCurrentMonth();
    final currentYear = getCurrentYear();

    final snapshot = await FirebaseFirestore.instance.collection('members').get();

    final unpaidMembers = snapshot.docs.where((doc) {
      var data = doc.data() as Map<String, dynamic>;
      Timestamp? timestamp = data['timestamp'] as Timestamp?;

      if (timestamp != null) {
        DateTime date = timestamp.toDate();
        return date.month < currentMonth || (date.month == currentMonth && date.year < currentYear);
      }
      return false;
    }).toList();

    if (unpaidMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All members have paid this month.')));
      return;
    }

    for (var member in unpaidMembers) {
      var data = member.data() as Map<String, dynamic>;
      String? phoneNumber = data['contactNumber'];  // Replace 'phoneNumber' with your actual field name
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        await sendSms(phoneNumber, 'Reminder: Please pay your membership dues for this month.');
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminders sent to unpaid members.')));
  }

  // Function to calculate unpaid members count
  Future<int> calculateUnpaidMembersCount() async {
    final currentMonth = getCurrentMonth();
    final currentYear = getCurrentYear();
    final snapshot = await FirebaseFirestore.instance.collection('members').get();

    final unpaidMembers = snapshot.docs.where((doc) {
      var data = doc.data() as Map<String, dynamic>;
      Timestamp? timestamp = data['timestamp'] as Timestamp?;

      if (timestamp != null) {
        DateTime date = timestamp.toDate();
        return date.month < currentMonth || (date.month == currentMonth && date.year < currentYear);
      }
      return false;
    }).toList();

    return unpaidMembers.length;
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
                // "Un-Paid Members" text
                const Text(
                  "Un-Paid Members",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Purple Button
                ElevatedButton(
                  onPressed: () {
                    sendReminderToUnpaidMembers(context); // Send reminders when button is clicked
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Button color
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Send Reminder",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space between button and unpaid members count
                // Unpaid Members Count
                FutureBuilder<int>(
                  future: calculateUnpaidMembersCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error fetching unpaid members count.',
                        style: TextStyle(color: Colors.red),
                      );
                    } else {
                      return Text(
                        'Total Unpaid Members: ${snapshot.data}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20), // Space between count and list
                // Members List
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('members').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No unpaid members found.'));
                      }

                      final currentMonth = getCurrentMonth();
                      final currentYear = getCurrentYear();

                      // Filter members whose timestamp is NOT in the current month or earlier
                      final members = snapshot.data!.docs.where((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        Timestamp? timestamp = data['timestamp'] as Timestamp?;

                        if (timestamp != null) {
                          DateTime date = timestamp.toDate();
                          return date.month < currentMonth || (date.month == currentMonth && date.year < currentYear);
                        }
                        return false;
                      }).toList();

                      if (members.isEmpty) {
                        return const Center(child: Text('All members have paid this month.'));
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
        color: Colors.black.withOpacity(0.6), // Slight transparency
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name field
          Text(
            "Name  :  $name",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          // NIC field
          Text(
            "NIC  :  $nic",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
