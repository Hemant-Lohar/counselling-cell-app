import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/counsellor/session.dart';
import 'package:counselling_cell_application/screens/counsellor/userList.dart';
import 'package:flutter/material.dart';

import 'counsellorHomePage.dart';

class ViewUser extends StatefulWidget {
  ViewUser({super.key, required this.id});
  final String id;
  @override
  State<ViewUser> createState() => _ViewUserState(this.id);
}

class _ViewUserState extends State<ViewUser> {
  String id;

  _ViewUserState(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ListView(
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(id)
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    var output = snapshot.data!.data();
                    var name = output!['name']; // <-- Your value
                    var age = output['age']; // <-- Your value
                    var gender = output['gender']; // <-- Your value
                    var mobile = output['mobile']; // <-- Your value
                    var dept = output['department']; // <-- Your value
                    var clas = output['class']; // <-- Your value
                    var division = output['division'];
                    var initial = name[0].toUpperCase(); // <-- Your value
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black45,
                            radius: 60,
                            child: Text(
                              initial,
                              style: const TextStyle(color: Colors.white,fontSize: 56),
                            ),
                          ),
                          const SizedBox(height:40),
                          Text('Name: $name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Age: $age',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Gender: $gender',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Department: $dept',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Class: $clas',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Division: $division',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Mobile: $mobile',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16)),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              )
            ],
          ),
        ));
  }
}
