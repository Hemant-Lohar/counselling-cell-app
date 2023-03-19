import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/login/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataClass.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String id = FirebaseAuth.instance.currentUser!.email!;
  String name= "";
  String Class="";
  String dept="";
  String div="";
  String Urn = "";
  String rec="";

  @override
  void initState(){
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        name=data!["name"];
        Class=data["class"];
        dept=data["department"];
        div=data["division"];
        Urn=data["urn"];
        rec=data["reccomendation"];
      });
    });

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
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
                    child: Text(name[0].toString().toUpperCase(),style: const TextStyle(color: Colors.white,fontSize: 40)),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: $name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),
                      
                      const SizedBox(
                        height: 40,
                      ),
                      Text('Email: $id',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),

                      const SizedBox(
                        height: 40,
                      ),
                      Text('Department: $dept',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),

                      const SizedBox(
                        height: 40,
                      ),
                      Text('Class: $Class',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),

                      const SizedBox(
                        height: 40,
                      ),
                      Text('Division: $div',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),

                      const SizedBox(
                        height: 40,
                      ),
                      Text('URN: $Urn',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),

                      const SizedBox(
                        height: 40,
                      ),
                      Text('Reccomendation: $rec',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16)),

                      const SizedBox(
                        height: 40,
                      ),


                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    logout().then((value) => {

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                          ModalRoute.withName('/') // Replace this with your root screen's route name (usually '/')
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
          ));
    });
  }
}
