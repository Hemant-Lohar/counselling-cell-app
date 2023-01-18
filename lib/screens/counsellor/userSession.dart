import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/counsellor/addSessionWithUser.dart';
import 'package:flutter/material.dart';

class UserSession extends StatefulWidget {
  const UserSession({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<UserSession> createState() => _UserSessionState(this.id);
}

class _UserSessionState extends State<UserSession> {
  final String id;
  _UserSessionState(this.id);
  // String username="";
  final String dateTime =
      "${DateTime.now().day.toString().padLeft(2,"0")}/${DateTime.now().month.toString().padLeft(2,"0")}/${DateTime.now().year}";
  // @override
  // void initState(){
  //
  //   FirebaseFirestore.instance.collection("users").doc(id).get().then((value){
  //     username=value.data()!["name"];
  //     log(username);
  //   });
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(id),
                    IconButton(
                      icon: const Icon(Icons.add_sharp),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>AddSessionWithUser(user: id)),
                        );
                      },
                    ),
                  ],
                ))),
        body: SingleChildScrollView(
          child: Column(
              children: [
                const Text("Previous Sessions"),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(id)
                      .collection("session")
                      .where("date", isLessThan: dateTime)
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState == ConnectionState.waiting)
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                          return ListTile(
                              title: Text(
                                "${data["timeStart"]}-${data["timeEnd"]}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,

                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text(
                                data['date'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {

                              }

                            // leading: CircleAvatar(
                            //   backgroundImage: NetworkImage(data['image']),
                            // ),
                          );
                        });
                  },
                ),
                const Text("Upcoming"),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(id)
                      .collection("session")
                      .where("date", isGreaterThanOrEqualTo: dateTime)
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState == ConnectionState.waiting)
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshots.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                          return ListTile(
                            title: Text(
                              "${data["timeStart"]}-${data["timeEnd"]}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              data['date'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),

                            onTap: () {},
                            // leading: CircleAvatar(
                            //   backgroundImage: NetworkImage(data['image']),
                            // ),
                          );
                        });
                  },
                ),
              ]),
        ));
  }
}
