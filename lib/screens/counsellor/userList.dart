import 'package:counselling_cell_application/screens/counsellor/addUser.dart';
import 'package:counselling_cell_application/screens/counsellor/viewUser.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'userPage.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.only(left: 10),
                            // decoration: BoxDecoration(
                            //   color: Colors.indigoAccent,
                            //   borderRadius: BorderRadius.circular(10),
                            //   // border: Border.all(color: Colors.black, width: 1)
                            // ),
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserPage( id: docs[index]['id'].toString(),)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                 // backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                child:Text(
                                  docs[index]['name'].toString(),
                                  style: const TextStyle(
                                    fontSize: 16,

                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          );
                        });
                  }
                },
              ),
            ],
          ),
        ),

    );
  }
}
