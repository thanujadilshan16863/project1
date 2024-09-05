import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMember {
  String nic; // Use NIC as a primary key
  String firstName;
  String lastName;
  String contactNumber;
  String address;
  String email;
  String emergencyContactName;
  String emergencyContactNumber;
  DateTime timestamp;
  DateTime timestampreg;  // Added timestampreg

  DocumentReference? documentReference;

  NewMember({
    required this.nic,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.address,
    required this.email,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
    required this.timestamp,
    required this.timestampreg, // Added this to constructor
    this.documentReference,
  });

  NewMember.fromMap(Map<String, dynamic> map, {this.documentReference})
      : nic = map['nic'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        contactNumber = map['contactNumber'],
        address = map['address'],
        email = map['email'],
        emergencyContactName = map['emergencyContactName'],
        emergencyContactNumber = map['emergencyContactNumber'],
        timestamp = (map['timestamp'] as Timestamp).toDate(),
        timestampreg = (map['timestampreg'] as Timestamp).toDate(); // Initialize timestampreg

  NewMember.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
      documentReference: snapshot.reference);

  Map<String, dynamic> toJson() {
    return {
      'nic': nic,
      'firstName': firstName,
      'lastName': lastName,
      'contactNumber': contactNumber,
      'address': address,
      'email': email,
      'emergencyContactName': emergencyContactName,
      'emergencyContactNumber': emergencyContactNumber,
      'timestamp': Timestamp.fromDate(timestamp),
      'timestampreg': Timestamp.fromDate(timestampreg), // Use timestampreg in toJson
    };
  }
}

class NewMemberScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emergencyContactNameController = TextEditingController();
  final TextEditingController emergencyContactNumberController = TextEditingController();

  NewMemberScreen({super.key});

  void _submitForm(BuildContext context) async {
    if (firstNameController.text.isEmpty) {
      _showSnackBar(context, 'First Name is required.');
      return;
    }
    if (lastNameController.text.isEmpty) {
      _showSnackBar(context, 'Last Name is required.');
      return;
    }
    if (contactNumberController.text.length != 10 ||
        !RegExp(r'^\d+$').hasMatch(contactNumberController.text)) {
      _showSnackBar(context, 'Contact Number should be 10 digits.');
      return;
    }
    if (!emailController.text.contains('@')) {
      _showSnackBar(context, 'Email should contain @ symbol.');
      return;
    }
    if (emergencyContactNumberController.text.length != 10 ||
        !RegExp(r'^\d+$').hasMatch(emergencyContactNumberController.text)) {
      _showSnackBar(context, 'Emergency Contact Number should be 10 digits.');
      return;
    }

    if (nicController.text.isEmpty) {
      _showSnackBar(context, 'NIC is required.');
      return;
    }

    DateTime now = DateTime.now();

    try {
      // Check if a member with the same NIC already exists
      DocumentSnapshot existingMember = await FirebaseFirestore.instance
          .collection('members')
          .doc(nicController.text)
          .get();

      if (existingMember.exists) {
        // Show error if NIC already exists
        _showSnackBar(context, 'Member with this NIC already exists.');
        return;
      }

      // Create a NewMember object from input values and the current timestamp
      NewMember newMember = NewMember(
        nic: nicController.text, // Use NIC as document ID
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        contactNumber: contactNumberController.text,
        address: addressController.text,
        email: emailController.text,
        emergencyContactName: emergencyContactNameController.text,
        emergencyContactNumber: emergencyContactNumberController.text,
        timestamp: now,
        timestampreg: now,  // Assign the same value to timestampreg
      );

      // Send data to Firestore using NIC as document ID
      await FirebaseFirestore.instance
          .collection('members')
          .doc(nicController.text) // Use NIC as the document ID
          .set(newMember.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully!')),
      );

      // Clear all fields after submission
      firstNameController.clear();
      lastNameController.clear();
      contactNumberController.clear();
      addressController.clear();
      nicController.clear();
      emailController.clear();
      emergencyContactNameController.clear();
      emergencyContactNumberController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add member: $e')),
      );
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/logo.jpg'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField('First Name', firstNameController),
                  const SizedBox(height: 10),
                  _buildTextField('Last Name', lastNameController),
                  const SizedBox(height: 10),
                  _buildTextField('Contact Number', contactNumberController),
                  const SizedBox(height: 10),
                  _buildTextField('Address', addressController),
                  const SizedBox(height: 10),
                  _buildTextField('NIC', nicController),
                  const SizedBox(height: 10),
                  _buildTextField('Email', emailController),
                  const SizedBox(height: 10),
                  _buildTextField(
                      'Emergency Contact Name', emergencyContactNameController),
                  const SizedBox(height: 10),
                  _buildTextField('Emergency Contact Number',
                      emergencyContactNumberController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _submitForm(context),
                    child: const Text('Submit'),
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
        fillColor: Colors.white12,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
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
}
