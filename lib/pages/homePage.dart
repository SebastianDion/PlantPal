import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Update _database initialization with the correct URL
  final DatabaseReference _database = FirebaseDatabase.instance
      .refFromURL('https://plantpal-ff2b6-default-rtdb.asia-southeast1.firebasedatabase.app/');

  int soilMoisture = 0;
  int uvSensor = 0;

  @override
  void initState() {
    super.initState();
    fetchData();  // Call fetchData here for a one-time retrieval
    _listenToFirebase();  // Set up real-time updates
  }

  // Function to fetch data once
  void fetchData() async {
    final snapshot = await _database.child('sensorData').get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        soilMoisture = data['soilMoisture'] ?? 0;
        uvSensor = data['uvSensor'] ?? 0;
      });
      print('Fetched Soil Moisture: $soilMoisture');
      print('Fetched UV Sensor: $uvSensor');
    } else {
      print('No data found at sensorData path');
    }
  }

  // Real-time listener
  void _listenToFirebase() {
    _database.child('sensorData').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          soilMoisture = data['soilMoisture'] as int? ?? 0;
          uvSensor = data['uvSensor'] as int? ?? 0;
        });
      } else {
        print('Unexpected data type: ${data.runtimeType}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
              child: Text(
                'Welcome to PlantPal',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xFF67A184),
                  fontSize: 26,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Soil Moisture: $soilMoisture',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'UV Sensor: $uvSensor',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
