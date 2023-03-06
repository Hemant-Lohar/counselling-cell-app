import 'package:counselling_cell_application/screens/counsellor/session.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/counsellor/userList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counsellorHomePage.dart';
import 'counsellorProfilePage.dart';
class CounsellorPage extends StatefulWidget {
  const CounsellorPage({Key? key}) : super(key: key);

  @override
  State<CounsellorPage> createState() => _CounsellorPageState();
}

class _CounsellorPageState extends State<CounsellorPage> {
  int currentIndex = 0;

  final username = FirebaseAuth.instance.currentUser!.email!;
  String name="";
  String initial = "";
  final screens = [
    const CounsellorHomePage(),
    const UserList(),
    const Session()
  ];

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection("counsellor")
        .doc(username)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        name = data["name"];
        initial=name[0].toUpperCase();
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Palette.primary,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items:  [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Palette.primary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Users',
              backgroundColor: Palette.primary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.class_),
              label: 'Sessions',
              backgroundColor: Palette.primary,
            ),
          ]),
    );
  }
}
