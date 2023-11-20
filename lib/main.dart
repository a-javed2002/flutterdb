import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/show.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDgU4xw2U4ABVjGMkCrFlcaRHiu893D5vs",
      appId: "1:596942908840:android:be036be89f7cb9b9f0019d",
      projectId: "flutter-680ed",
      messagingSenderId: "596942908840p",
      // Add other necessary fields if available in your Firebase config JSON
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _employeeName;
  late String _department;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Employee Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter employee name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _employeeName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Department'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department';
                  }
                  return null;
                },
                onSaved: (value) {
                  _department = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Save data to Firestore including current date/time
                    await _firestore.collection('Employee').add({
                      'employeeName': _employeeName,
                      'department': _department,
                      'timestamp': DateTime.now(),
                    });

                    print("Inserted");

                    // Reset form after submission
                    _formKey.currentState!.reset();
                  }
                },
                child: Text('Submit'),
              ),

              IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeList()),
              );
            },
          ),
            ],
          ),
        ),
      ),
    );
  }
}