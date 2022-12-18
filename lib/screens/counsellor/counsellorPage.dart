import 'package:counselling_cell_application/screens/counsellor/counsellorHomePage.dart';
import 'package:counselling_cell_application/screens/counsellor/counsellorProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CounsellorPage extends StatefulWidget {
  const CounsellorPage({Key? key}) : super(key: key);

  @override
  State<CounsellorPage> createState() => _CounsellorPageState();
}

class _CounsellorPageState extends State<CounsellorPage> {
  int currentIndex = 0;

  final screens = [
    const CounsellorHomePage(),
    const Center(child: Text('Profile', style: TextStyle(fontSize: 40)))
  ];

  @override
  Widget build(BuildContext context) {
    final username = FirebaseAuth.instance.currentUser!.email!;
    String name = username.substring(0, username.indexOf('@'));
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, $name'),
        actions: <Widget>[
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CounsellorProfile()));
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text('H'),
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
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue,
            ),
          ]),
    );
  }
}
