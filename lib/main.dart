import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(PillTrackerApp());
}

class PillTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: PillTrackerPage(),
    );
  }
}

class PillTrackerPage extends StatefulWidget {
  @override
  _PillTrackerPageState createState() => _PillTrackerPageState();
}

class _PillTrackerPageState extends State<PillTrackerPage> {
  List<bool> pillTaken = List.generate(10, (index) => false);
  String todayDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadPillData();
  }

  // Load the saved pill data from shared preferences
  Future<void> _loadPillData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedPills = prefs.getStringList('pillTaken');
    if (savedPills != null && savedPills.length == pillTaken.length) {
      setState(() {
        pillTaken = savedPills.map((item) => item == 'true').toList();
      });
    }
  }

  // Save the pill data to shared preferences
  Future<void> _savePillData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> pillsToSave =
        pillTaken.map((item) => item.toString()).toList();
    await prefs.setStringList('pillTaken', pillsToSave);
  }

  void onPillTaken(int index) {
    setState(() {
      pillTaken[index] = true;
    });
    _savePillData(); // Save data each time a pill is taken
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double pillSize = width * 0.12; // Adjust pill size relative to screen width

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/background.jpg'), // Beautiful background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.05), // Space for status bar
              Text(
                'Pill Tracker Dashboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'Today\'s Date: $todayDate',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: height * 0.03),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Has she taken her pill?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: height * 0.02,
                        crossAxisSpacing: width * 0.02,
                        childAspectRatio: 1,
                      ),
                      itemCount: pillTaken.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => onPillTaken(index),
                          child: Container(
                            width: pillSize,
                            height: pillSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: pillTaken[index]
                                  ? Colors.transparent
                                  : Colors.blueAccent,
                              border: Border.all(
                                color: pillTaken[index]
                                    ? Colors.grey.shade400
                                    : Colors.blueAccent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              gradient: pillTaken[index]
                                  ? LinearGradient(
                                      colors: [
                                        Colors.grey.shade300,
                                        Colors.grey.shade100,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: pillTaken[index]
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.grey.shade400,
                                      size: 30,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              Text(
                'Tap on the pill after taking it',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
