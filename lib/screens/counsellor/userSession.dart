import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/counsellor/addSessionWithUser.dart';
import 'package:counselling_cell_application/theme/palette.dart';
import 'package:flutter/material.dart';

class UserSession extends StatefulWidget {
  const UserSession({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<UserSession> createState() => _UserSessionState();
}

class _UserSessionState extends State<UserSession> {
  late final String id;

  // String username="";
  final String dateTime =
      "${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";
  @override
  void initState() {
    super.initState();
    id = widget.id;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: const BackButton(color: Colors.white),
            backgroundColor: Palette.secondary,
            title: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  id,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                CircleAvatar(
                  backgroundColor: Palette.ternary[800],
                  child: IconButton(
                    // style:  const ButtonStyle(backgroundColor: Colors.orange),
                    icon: const Icon(
                      Icons.add_sharp,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddSessionWithUser(user: id, request: "")),
                      );
                    },
                  ),
                ),
              ],
            ))),
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(id),
                //     IconButton(
                //       icon: const Icon(Icons.add_sharp),
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) =>AddSessionWithUser(user: id,request: "")),
                //         );
                //       },
                //     ),
                //   ],
                // ))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                tileColor: Palette.tileback,
                                leading: CircleAvatar(
                                  backgroundColor: Palette.primary,
                                  child: const Text(
                                    "H",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  "Date - ${data['date']}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Time - ${data["timeStart"]}-${data["timeEnd"]}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,

                                    // fontWeight: FontWeight.bold
                                  ),
                                ),
                                onTap: () {}

                                // leading: CircleAvatar(
                                //   backgroundImage: NetworkImage(data['image']),
                                // ),
                                );
                          });
                },
              ),
              const SizedBox(
                height: 10,
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
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tileColor: Palette.tileback,
                                  leading: CircleAvatar(
                                    backgroundColor: Palette.primary,
                                    child: Text(
                                      id[0].toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    "Date - ${data['date']}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "Time - ${data["timeStart"]}-${data["timeEnd"]}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      // fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  onTap: () {},
                                  // leading: CircleAvatar(
                                  //   backgroundImage: NetworkImage(data['image']),
                                  // ),
                                ),
                              ],
                            );
                          });
                },
              ),
            ]),
          ),
        ));
  }
}
