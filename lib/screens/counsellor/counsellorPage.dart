import 'package:counselling_cell_application/screens/counsellor/session.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../theme/Palette.dart';
import 'counsellorHomePage.dart';
import 'userList.dart';
import 'Chart.dart';

class CounsellorPage extends StatefulWidget {
  const CounsellorPage({Key? key}) : super(key: key);

  @override
  State<CounsellorPage> createState() => _CounsellorPageState();
}

class _CounsellorPageState extends State<CounsellorPage> {
  int currentIndex = 0;

  final username = FirebaseAuth.instance.currentUser!.email!;
  String name = "";
  String initial = "";
  final screens = [
    const Chart(),
    const CounsellorHomePage(),
    const UserList(),
    const Session()
  ];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("counsellor")
        .doc(username)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        name = data["name"];
        initial = name[0].toUpperCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
          type: BottomNavigationBarType.fixed, // This is all you need!
          backgroundColor: Colors.white,
          selectedItemColor: Palette.primary,
          selectedFontSize: 10,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Palette.primary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Requests',
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
