import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/login/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClass.dart';

class CounsellorProfile extends StatefulWidget {
  const CounsellorProfile({Key? key}) : super(key: key);

  @override
  State<CounsellorProfile> createState() => _CounsellorProfileState();
}

class _CounsellorProfileState extends State<CounsellorProfile> {
  final username = FirebaseAuth.instance.currentUser!.email!;
  String name = "";
  String initial = "";
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
        initial = name[0].toString().toUpperCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Consumer<DataClass>(builder: (context, modal, child) {
    //   String username = modal.username;
    //   return Scaffold(
    //     appBar: AppBar(
    //       leading: const BackButton(color: Colors.black),
    //       backgroundColor: Colors.transparent,
    //       elevation: 0,
    //     ),
    //     body: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 40),
    //         child: Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               CircleAvatar(
    //                 backgroundColor: Colors.black45,
    //                 radius: 60,
    //                 child: Text(
    //                   initial,
    //                   style: const TextStyle(color: Colors.white, fontSize: 56),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 40,
    //               ),
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     Text('Name: $name',
    //         textAlign: TextAlign.left,
    //         style: const TextStyle(
    //             fontWeight: FontWeight.bold,
    //             color: Colors.black,
    //             fontSize: 16)),
    //   ],
    // ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Text('Email: $username',
    //                       style: const TextStyle(
    //                           fontWeight: FontWeight.bold,
    //                           color: Colors.black,
    //                           fontSize: 16)),
    //                 ],
    //               ),
    //               const SizedBox(
    //                 height: 40,
    //               ),
    //               ElevatedButton(
    //                 onPressed: () {
    //                   logout().then((value) => {
    //                         Navigator.popUntil(
    //                           context,
    //                           ModalRoute.withName('/'),
    //                         ),
    //                         Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                               builder: (context) => const LoginPage()),
    //                         )
    //                       });
    //                 },
    //                 style: ElevatedButton.styleFrom(
    //                   // backgroundColor: Colors.black,
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 40, vertical: 16),
    //                   shape: const StadiumBorder(),
    //                 ),
    //                 child: const Text('logout'),
    //               ),
    //             ],
    //           ),
    //         )),
    //   );
    // });
    return Consumer<DataClass>(builder: (context, modal, child) {
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
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 60,
                    child: Text(initial,style:  const TextStyle(color: Colors.white, fontSize: 40),),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Name: $name',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),
                      Text('Email: $username',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          logout().then((value) => {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const LoginPage()),
                                    ModalRoute.withName(
                                        '/') // Replace this with your root screen's route name (usually '/')
                                    ),
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('logout'),
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
