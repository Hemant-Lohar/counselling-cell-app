import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/user/userProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'assesmentPage.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final username = FirebaseAuth.instance.currentUser!.email!;
  late bool showAssessment;
  Widget getAssessmentButton(){
    FirebaseFirestore.
    instance.
    collection("users").
    doc(username).
    get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        setState(() {
          showAssessment=data["assessment"];
        });


      },
    );
    if(showAssessment){
      return Container();
    }
    else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcome User, Take a short assessment to improve your experience"),
          ElevatedButton(onPressed: (){
            FirebaseFirestore.instance.collection("users").doc(username).update(
                {"assessment":true});
            Navigator.push(
              context,
              // ignore: prefer_const_constructors
              MaterialPageRoute(builder: (context) => AssesmentPage()),
            );
          }, child: const Text("Take Assessment")),
        ],
      );
    }


  }


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String name = username.substring(0, username.indexOf('@'));
    String initial = username[0].toUpperCase();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hi, $name',
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfilePage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 51, 51, 51),
                    child: Text(
                      initial,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Home"),
              getAssessmentButton(),
            ],
          ),
        ));
  }
}
