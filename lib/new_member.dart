import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMember {
  String firstName;
  String lastName;
  String contactNumber;
  String address;
  String nic;
  String email;
  String emergencyContactName;
  String emergencyContactNumber;

  DocumentReference? documentReference;

  NewMember({
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.address,
    required this.nic,
    required this.email,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
    this.documentReference,
  });

  NewMember.fromMap(Map<String, dynamic> map, {this.documentReference})
      : firstName = map['firstName'],
        lastName = map['lastName'],
        contactNumber = map['contactNumber'],
        address = map['address'],
        nic = map['nic'],
        email = map['email'],
        emergencyContactName = map['emergencyContactName'],
        emergencyContactNumber = map['emergencyContactNumber'];

  NewMember.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            documentReference: snapshot.reference);

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'contactNumber': contactNumber,
      'address': address,
      'nic': nic,
      'email': email,
      'emergencyContactName': emergencyContactName,
      'emergencyContactNumber': emergencyContactNumber,
    };
  }
}

class NewMemberScreen extends StatelessWidget {
  // Controllers to capture input values
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emergencyContactNameController =
      TextEditingController();
  final TextEditingController emergencyContactNumberController =
      TextEditingController();

  NewMemberScreen({super.key});

  // Function to handle form submission
  void _submitForm(BuildContext context) async {
    // Create a NewMember object from input values
    NewMember newMember = NewMember(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      contactNumber: contactNumberController.text,
      address: addressController.text,
      nic: nicController.text,
      email: emailController.text,
      emergencyContactName: emergencyContactNameController.text,
      emergencyContactNumber: emergencyContactNumberController.text,
    );

    try {
      // Send data to Firestore
      await FirebaseFirestore.instance
          .collection('members')
          .add(newMember.toJson());

      // Show success message
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
      // Show error message if there is a failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add member: $e')),
      );
    }
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                // Logo
                const Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        AssetImage('assets/logo.jpg'), // Replace with your logo path
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
                _buildTextField('Emergency Contact Name', emergencyContactNameController),
                const SizedBox(height: 10),
                _buildTextField('Emergency Contact Number', emergencyContactNumberController),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => _submitForm(context), // Call the submit function here
                  child: const Text('Submit'),
                ),
              ],
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
