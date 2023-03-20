import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final String id = FirebaseAuth.instance.currentUser!.email!;


  Set<String> userList = {};
  final genderMap = {"Male":0,"Female":0,"LGBTQ+":0};
  final classMap = {};
  final deptMap = {};
  void getData()async{
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection("users").get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    for (var doc in documents) {
      if (doc["gender"] != null) {
        genderMap.update(
          doc["gender"]!,
              (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
      if (doc["department"] != null) {
        deptMap.update(
          doc["department"]!,
              (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
      if (doc["class"] != null) {
        classMap.update(
          doc["class"]!,
              (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }
    log(genderMap.toString());

  }
@override
void initState(){
    super.initState();
    getData();
}

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Hello"));
  }
}