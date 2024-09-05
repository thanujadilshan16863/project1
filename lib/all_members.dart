import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllMembers extends StatefulWidget {
  const AllMembers({super.key});

  @override
  _AllMembersState createState() => _AllMembersState();
}

class _AllMembersState extends State<AllMembers> {
  final TextEditingController _nicController = TextEditingController();
  String? _searchNIC;
  Stream<QuerySnapshot>? _membersStream;

  @override
  void initState() {
    super.initState();
    // Initialize with all members' stream
    _membersStream = FirebaseFirestore.instance.collection('members').snapshots();
  }

  void _searchMembers() {
    setState(() {
      _searchNIC = _nicController.text.trim();
      if (_searchNIC != null && _searchNIC!.isNotEmpty) {
        // Query Firestore for members with the specified NIC
        _membersStream = FirebaseFirestore.instance
            .collection('members')
            .where('nic', isEqualTo: _searchNIC)
            .snapshots();
      } else {
        // If NIC is empty, show all members
        _membersStream = FirebaseFirestore.instance.collection('members').snapshots();
      }
    });
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
            child: SingleChildScrollView( // Makes the content scrollable
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
                  // "All Members" text
                  const Text(
                    "All Members",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // NIC Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // NIC Input Field
                        Expanded(
                          child: TextField(
                            controller: _nicController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white30,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Enter NIC',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Search Button
                        ElevatedButton(
                          onPressed: _searchMembers, // Search logic
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ), // Button background color
                          ),
                          child: const Text('Search'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Members List
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6, // Limits height to fit within the screen
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _membersStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No members found.'));
                        }

                        final members = snapshot.data!.docs;

                        return ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            var memberData = members[index].data() as Map<String, dynamic>;
                            return MemberDetailsCard(memberData: memberData);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MemberDetailsCard extends StatelessWidget {
  final Map<String, dynamic> memberData;

  const MemberDetailsCard({super.key, required this.memberData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10), // Add margin between cards
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Slight transparency
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Member Details fields from Firebase data
          buildMemberDetailText("First Name : ${memberData['firstName'] ?? ''}"),
          buildMemberDetailText("Last Name : ${memberData['lastName'] ?? ''}"),
          buildMemberDetailText("NIC : ${memberData['nic'] ?? ''}"),
          buildMemberDetailText("Contact Number : ${memberData['contactNumber'] ?? ''}"),
          buildMemberDetailText("Address : ${memberData['address'] ?? ''}"),
          buildMemberDetailText("Email : ${memberData['email'] ?? ''}"),
          buildMemberDetailText("Emergency Name : ${memberData['emergencyContactName'] ?? ''}"),
          buildMemberDetailText("Emergency Contact : ${memberData['emergencyContactNumber'] ?? ''}"),
        ],
      ),
    );
  }

  Widget buildMemberDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
