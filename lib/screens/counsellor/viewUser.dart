import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/counsellor/addUser.dart';
import 'package:counselling_cell_application/theme/palette.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewUser extends StatefulWidget {
  const ViewUser({super.key, required this.id});
  final String id;
  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  late String id ;
  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Palette.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          // textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error = ${snapshot.error}');
                } else if (snapshot.hasData) {
                  var output = snapshot.data!.data();

                  var name = output!['name']; // <-- Your value
                  var age = output['age']; // <-- Your value
                  var gender = output['gender']; // <-- Your value
                  var mobile = output['mobile']; // <-- Your value
                  var dept = output['department']; // <-- Your value
                  var clas = output['class']; // <-- Your value
                  var division = output['division'];

                  var initial = name[0].toUpperCase();
                  // print(output.containsValue('referral'));

                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        const SizedBox(height: 30),
                        CircleAvatar(
                          backgroundColor: Palette.secondary,
                          radius: 50,
                          child: Text(
                            initial,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 48),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: $name',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Age: $age',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Gender: $gender',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Department: $dept',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Class : $clas',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Division : $division',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Mobile : $mobile',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            const SizedBox(
                              height: 30,
                            ),
                            //
                            // Text('Reffered By : $referedby',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Familydetails : $familydetails',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Reason for Reffered : $reasonreferral',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Family History : $familyhistory',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Observation: $observation',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Reccomendation : $reccomendation',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                          ],
                        ),
                      ]));
                } else {
                  return const Center(child: CircularProgressIndicator());
                } // <-- Your value
              },
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error = ${snapshot.error}');
                } else if (snapshot.hasData) {
                  var output = snapshot.data!.data();

                  var referedby = output!['referral'];
                  var familydetails = output['familydetails'];
                  var familyhistory = output['familyhistory'];
                  var reasonreferral = output['reasonreferral'];
                  var observation = output['observation'];
                  var reccomendation = output['observation'];

                  // print(output.containsValue('referral'));

                  if (output.containsKey('referral')) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Referred By : $referedby',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Familydetails : $familydetails',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Reason for Referral : $reasonreferral',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Family History : $familyhistory',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Observation: $observation',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Reccomendation : $reccomendation',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        if(id.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>AddUser(id:id)));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Palette.secondary),
                      ),
                      child: const Text("Enter Details"),
                    );
                  } // <-- Your value

                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
