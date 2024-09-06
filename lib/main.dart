import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  // Import Firebase Core
import 'login.dart';  // Import the LoginScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   try {

    await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: "FY",
          appId: 'c9', messagingSenderId: '612', projectId: '6')
    );  // Make sure Firebase is initialized before running the app

  } catch (e) {

    print('Error initializing Firebase: $e');  // Handle potential errors during initialization

  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),  // Initialize Firebase
      builder: (context, snapshot) {
        // Firebase initialization is complete
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: ThemeData.dark(),
            home: const LoginScreen(),  // Show your main screen
          );
        }

        // Firebase initialization failed
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error initializing Firebase: ${snapshot.error}'),
              ),
            ),
          );
        }

        // Show a loading screen while waiting for Firebase to initialize
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
