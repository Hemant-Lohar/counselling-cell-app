
import 'package:counselling_cell_application/screens/counsellor/session.dart';
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

  final screens = [
    const CounsellorHomePage(),
    const UserList(),
    const Session()
  ];

  @override
  Widget build(BuildContext context) {
    final username = FirebaseAuth.instance.currentUser!.email!;
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
                        builder: (context) => const CounsellorProfile()));
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
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Users',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.class_),
              label: 'Sessions',
              backgroundColor: Colors.blue,
            ),
          ]
      ),
    );
  }
}
