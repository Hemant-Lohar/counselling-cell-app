import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(id)
                      .snapshots(),
                  builder: (context, snapshot) {
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
                      var referedby = output['referral'];
                      var familydetails = output['familydetails'];
                      var familyhistory = output['familyhistory'];
                      var reasonreferral = output['reasonreferral'];
                      var observation = output['observation'];
                      var reccomendation = output['observation'];

                      var initial = name[0].toUpperCase();
                      // print(output.containsValue('referral'));
                      
                      if (output.containsKey('referral')) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black45,
                                radius: 60,
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 56),
                                ),
                              ),
                              const SizedBox(height: 40),
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
                              const Divider(
                                height: 10,
                                thickness: 2,
                                indent: 20,
                                endIndent: 0,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Reffered By: $referedby',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Familydetails: $familydetails',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Reason for Reffered: $reasonreferral',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Family History: $familyhistory',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Observation: $observation',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Reccomendation: $reccomendation',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black45,
                                radius: 60,
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 56),
                                ),
                              ),
                              const SizedBox(height: 40),
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
                              const Divider(
                                height: 10,
                                thickness: 2,
                                indent: 20,
                                endIndent: 0,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        );
                      } // <-- Your value

                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                )
              ],
            ),
          ),
        ));
  }
}

