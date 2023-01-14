import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/login/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClass.dart';

class CounsellorProfile extends StatefulWidget {
  const CounsellorProfile({Key? key}) : super(key: key);

  @override
  State<CounsellorProfile> createState() => _CounsellorProfileState();
}

class _CounsellorProfileState extends State<CounsellorProfile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataClass>(builder: (context, modal, child) {
      String username = modal.username;
      return Scaffold(
          appBar: AppBar(
            leading: const BackButton(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ListView(children: [
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('counsellor')
                    .doc(username)
                    .get(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error = ${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    var data = snapshot.data!.data();
                    var name = data!['name']; // <-- Your value
                    var initial =
                        name[0].toString().toUpperCase(); //
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
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Name: $name',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Email: $username',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16)),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Logout().then((value) => {
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName('/'),
                        ),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        )
                      });
                },
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Logout'),
              ),
            ]),
          ));
    });
  }
}
