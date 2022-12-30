import 'package:counselling_cell_application/screens/user/assesmentPage.dart';
import 'package:counselling_cell_application/screens/user/userHomePage.dart';
import 'package:counselling_cell_application/screens/user/userProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int currentIndex = 0;

  final screens = [
    const UserHomePage(),
    const AssesmentPage(),
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
                        builder: (context) => const UserProfilePage()));
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 51, 51, 51),
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
              icon: Icon(Icons.search),
              label: 'Home',
              backgroundColor: Colors.blue,
            ),
            
          ]),
    );
  }
}
