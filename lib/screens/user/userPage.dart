import 'dart:async';
import 'dart:developer';
import 'package:counselling_cell_application/screens/user/userHomePage.dart';
import 'package:counselling_cell_application/theme/palette.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/user/userProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'history.dart';
import 'notifications.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final String username = FirebaseAuth.instance.currentUser!.email!;
  bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  Timer? timer;
  String initial = "";
  String name = "";
  int currentIndex = 0;
  final screens = [const UserHomePage(), const History()];

  @override
  void initState() {
    super.initState();
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3),(_){
        checkEmailVerified();
      });
    }
    FirebaseFirestore.instance
        .collection("users")
        .doc(username)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        name = data["name"];
        initial = username[0].toUpperCase();
      });
    });
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  Future checkEmailVerified()async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified)timer?.cancel();
  }
  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Hi, $name',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              elevation: 0,
              backgroundColor: Palette.secondary,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      // ignore: prefer_const_constructors
                      MaterialPageRoute(
                          builder: (context) => const Notifications()),
                    );
                  },
                ),
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
                        backgroundColor: Palette.primary,
                        child: Text(
                          initial,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              ],
            ),
            body: screens[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedItemColor: Palette.primary,
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
                    icon: Icon(Icons.history),
                    label: 'History',
                    backgroundColor: Palette.primary,
                  ),
                ]),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify Email'),
            ),
          ); // Scaffold;
  }


}
