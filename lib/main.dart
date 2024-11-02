import 'package:flutter/material.dart';
import 'package:iot/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT app',
      theme: ThemeData(
      
      ),
       debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}

