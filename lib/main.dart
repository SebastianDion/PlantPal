import 'package:flutter/material.dart';
import 'package:iot/pages/splash.dart'; // Make sure this is implemented correctly
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure WidgetsFlutterxBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (only once)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform, // Ensure this points to the correct Firebase options
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const Splash(), // Replace with a temporary widget if needed
    );
  }
}
