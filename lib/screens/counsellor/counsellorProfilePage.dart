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
      String name = modal.username;
      return Scaffold(
          appBar: AppBar(
            leading: const BackButton(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: ListView(
              children: [
                const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 60,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Name: $name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),
                      Text('Name: $name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),
                      Text('Name: $name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),
                      const SizedBox(
                        height: 40,
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
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}