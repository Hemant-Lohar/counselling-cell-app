import 'package:counselling_cell_application/screens/counsellor/session.dart';
import 'package:counselling_cell_application/screens/counsellor/userList.dart';
import 'package:counselling_cell_application/screens/counsellor/userSession.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addUser.dart';
import 'counsellorHomePage.dart';
import 'counsellorProfilePage.dart';
import 'viewUser.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.id});
  final String id;

  @override
  State<UserPage> createState() => _UserPageState(this.id);
}

class _UserPageState extends State<UserPage> {
  final String id;

  _UserPageState(this.id);

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      ViewUser(id: id),
      AddUser(id: id),
      UserSession(id: id),
    ];
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'User: $id',
      //     style: const TextStyle(color: Colors.black),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp),
              label: 'Basic Info',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'Add Info',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Case History',
              backgroundColor: Colors.blue,
            ),
          ]),
    );
  }
}
