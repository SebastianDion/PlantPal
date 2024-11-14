import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseReference _database = FirebaseDatabase.instance.refFromURL(
      'https://plantpal-ff2b6-default-rtdb.asia-southeast1.firebasedatabase.app/');

  int soilMoisture = 0;
  int uvSensor = 0;

  @override
  void initState() {
    super.initState();
    fetchData(); // Call fetchData here for a one-time retrieval
    _listenToFirebase(); // Set up real-time updates
  }

  // Function to fetch data once with error handling
  Future<void> fetchData() async {
    try {
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
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  // Real-time listener with optimized setState
  void _listenToFirebase() {
    _database.child('sensorData').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        final newSoilMoisture = data['soilMoisture'] as int? ?? 0;
        final newUvSensor = data['uvSensor'] as int? ?? 0;

        if (newSoilMoisture != soilMoisture || newUvSensor != uvSensor) {
          setState(() {
            soilMoisture = newSoilMoisture;
            uvSensor = newUvSensor;
          });
        }
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
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: Text(
                  'Welcome to PlantPal',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 61, 96, 77),
                          Color.fromARGB(255, 110, 188, 169)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFACD1AF),
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: const LinearGradient(
      begin: Alignment.topCenter,     // Start the gradient at the top
      end: Alignment.bottomCenter,    // End the gradient at the bottom
      colors: [
        Color(0xFFACD1AF),                  // Start color at the top
        Color.fromARGB(217, 205, 238, 207),                   // End color at the bottom
      ],
    ),
                    ),
                    child: Text(
                      'Soil Moisture: $soilMoisture',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFACD1AF),
                      borderRadius: BorderRadius.circular(10.0),
                        gradient: const LinearGradient(
      begin: Alignment.topCenter,     // Start the gradient at the top
      end: Alignment.bottomCenter,    // End the gradient at the bottom
      colors: [
        Color(0xFFACD1AF),                  // Start color at the top
        Color.fromARGB(217, 205, 238, 207),                  // End color at the bottom
      ],
    ),
                    ),
                    child: Text(
                      'UV Sensor: $uvSensor',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                if (uvSensor > 1000) // Conditional display of "PUMP OFF"
                 Row(
  children: [
    // Pump Status Label
    // Text(
    //   'Pump Status:', 
    //   style: TextStyle(
    //     fontSize: 20,
    //     fontWeight: FontWeight.w600,
    //     color: Colors.black,
    //   ),
    // ),
    // const SizedBox(width: 10), // Add space between label and container
    
    // Pump Status Container
    Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: uvSensor > 1000 ? Colors.red[100] : Colors.green[100], // Background color to indicate status
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        uvSensor > 1000 ? 'pump OFF' : 'pump ON',
        style: TextStyle(
          color: uvSensor > 1000 ? Colors.red : Colors.green,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
