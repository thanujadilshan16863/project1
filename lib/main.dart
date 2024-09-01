import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  // Import Firebase Core
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';  // Import the LoginScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();  // Make sure Firebase is initialized before running the app
  } catch (e) {
    print('Error initializing Firebase: $e');  // Handle potential errors during initialization
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const LoginScreen(),  // Use the LoginScreen from login.dart
    );
  }
}
