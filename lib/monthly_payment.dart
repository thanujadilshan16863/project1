import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // To format the month from timestamp

class MonthlyPaymentScreen extends StatefulWidget {
  MonthlyPaymentScreen({super.key});

  @override
  _MonthlyPaymentScreenState createState() => _MonthlyPaymentScreenState();
}

class _MonthlyPaymentScreenState extends State<MonthlyPaymentScreen> {
  final TextEditingController nicController = TextEditingController();
  String? memberName; // Variable to store the member name
  String? paymentMonth; // Variable to store the payment month
  String? selectedMonth; // Variable to store the selected month

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/home1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20),
                  // Logo
                  const Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/logo.jpg'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Enter NIC
                  _buildTextField('Enter NIC', nicController),
                  const SizedBox(height: 20),
                  // Check Payment Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      _checkPayment(context);
                    },
                    child: const Text('Check Payment'),
                  ),
                  const SizedBox(height: 20),
                  // Display Paid Months
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Name: ${memberName ?? 'Not Found'}    Month: ${paymentMonth ?? 'Not Found'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Select Month Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: selectedMonth,
                      hint: const Text('Select Month', style: TextStyle(color: Colors.white)),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      dropdownColor: Colors.grey[800],
                      isExpanded: true,
                      underline: const SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMonth = newValue;
                        });
                      },
                      items: <String>[
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Add Payment Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      _addPayment(context);
                    },
                    child: const Text('Add Payment'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _checkPayment(BuildContext context) async {
    String enteredNIC = nicController.text.trim();

    if (enteredNIC.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter NIC')),
      );
      return;
    }

    try {
      // Fetch data from Firestore using NIC as the document ID
      DocumentSnapshot memberSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .doc(enteredNIC)
          .get();

      if (memberSnapshot.exists) {
        // If member exists, extract name and timestamp
        var memberData = memberSnapshot.data() as Map<String, dynamic>;
        memberName = "${memberData['firstName']} ${memberData['lastName']}";

        Timestamp timestamp = memberData['timestamp'];
        DateTime dateTime = timestamp.toDate();

        // Get the month from the timestamp
        paymentMonth = DateFormat('MMMM').format(dateTime); // Formats to month name

        // Refresh the screen to display fetched data
        setState(() {});
      } else {
        memberName = 'Not Found';
        paymentMonth = 'Not Found';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member with this NIC does not exist.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching payment info: $e')),
      );
    }
  }

  Future<void> _addPayment(BuildContext context) async {
    if (nicController.text.isEmpty || selectedMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please check NIC and select a month')),
      );
      return;
    }

    try {
      // Update the Firestore document with the new month
      DocumentReference memberDoc = FirebaseFirestore.instance
          .collection('members')
          .doc(nicController.text);

      DateTime now = DateTime.now();
      // Create a new timestamp with the selected month and current year
      DateTime updatedTimestamp = DateTime(
        now.year,
        _monthFromString(selectedMonth!),
        now.day,
        now.hour,
        now.minute,
        now.second,
      );

      await memberDoc.update({
        'timestamp': Timestamp.fromDate(updatedTimestamp),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment added successfully!')),
      );

      // Refresh the screen to update the payment month
      setState(() {
        paymentMonth = DateFormat('MMMM').format(updatedTimestamp);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding payment: $e')),
      );
    }
  }

  int _monthFromString(String month) {
    const monthMap = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    return monthMap[month] ?? DateTime.now().month;
  }
}
