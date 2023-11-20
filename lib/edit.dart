import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEmployeeScreen extends StatefulWidget {
  final String documentId;

  const EditEmployeeScreen({required this.documentId});

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  late TextEditingController _departmentController;

  String _employeeName = ''; // Added to hold employee name

  @override
  void initState() {
    super.initState();
    _departmentController = TextEditingController();
    fetchEmployeeDetails();
  }

  @override
  void dispose() {
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> fetchEmployeeDetails() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Employee').doc(widget.documentId).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    setState(() {
      _employeeName = data['employeeName']; // Set employee name
      _departmentController.text = data['department'];
    });
  }

  Future<void> updateDepartment() async {
    await FirebaseFirestore.instance.collection('Employee').doc(widget.documentId).update({
      'department': _departmentController.text,
    });
    Navigator.pop(context); // Navigate back to the previous screen after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit $_employeeName\'s Department'), // Show employee name in the title
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Employee Name: $_employeeName', // Display employee name as read-only text
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _departmentController,
              decoration: InputDecoration(labelText: 'Department'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateDepartment(); // Update the department
              },
              child: Text('Update Department'),
            ),
          ],
        ),
      ),
    );
  }
}
