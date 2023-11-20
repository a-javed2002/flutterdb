import 'package:dbapp/edit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Employee').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['employeeName']),
                subtitle: Text(data['department']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditEmployeeScreen(
                                documentId: documents[index].id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Delete the record from Firestore
                        FirebaseFirestore.instance
                            .collection('Employee')
                            .doc(documents[index].id)
                            .delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
