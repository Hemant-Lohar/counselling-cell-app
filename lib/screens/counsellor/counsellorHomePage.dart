import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addSessionWithUser.dart';
import 'counsellorPage.dart';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../theme/Palette.dart';
import 'counsellorProfilePage.dart';

class CounsellorHomePage extends StatefulWidget {
  const CounsellorHomePage({Key? key}) : super(key: key);

  @override
  State<CounsellorHomePage> createState() => _CounsellorHomePageState();
}

class _CounsellorHomePageState extends State<CounsellorHomePage> {
  final username = FirebaseAuth.instance.currentUser!.email!;
  String name = "";
  String initial = "";
  final String dateTime =
      "${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";

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
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Hi, $name',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          elevation: 0,
          backgroundColor: Palette.primary[50],
          actions: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CounsellorProfile()));
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
                ))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(children: [getNewRequests(), getRequests()]),
            )));
  }

  Widget getRequests() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("counsellor")
            .doc(username)
            .collection("Requests")
            .where("firstTime", isEqualTo: "false")
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshots.data!.size == 0) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Center(
                    child: Text(
                      "You have no requests from existing users!",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),
                ]);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Requests from existing users",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshots.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        horizontalTitleGap: 0.0,
                        title: Text(
                          data["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddSessionWithUser(
                                                user: data["user"],
                                                request: snapshots
                                                    .data!.docs[index].id),
                                      ));
                                },
                                icon: const Icon(Icons.check)),
                            IconButton(
                                onPressed: () {
                                  Future.delayed(
                                      const Duration(seconds: 0),
                                      () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return getAlertDialog(
                                                data["user"],
                                                snapshots.data!.docs[index].id,
                                                data["date"],
                                                data["time"]);
                                          }));
                                },
                                icon: const Icon(Icons.close)),
                          ],
                        ),
                        subtitle: Text(
                          "Problem:${data["problem"]}\nPreferred mode:${data['mode']}",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            // fontWeight: FontWeight.bold
                          ),
                        ),

                        onTap: () {},
                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage(data['image']),
                        // ),
                      );
                    }),
              ],
            );
          }
        });
  }

  Widget getNewRequests() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("counsellor")
            .doc(username)
            .collection("Requests")
            .where("firstTime", isEqualTo: "true")
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshots.data!.size == 0) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "You have no new requests!",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),
                ]);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Requests from new users",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshots.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        horizontalTitleGap: 0.0,
                        title: Text(
                          data["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddSessionWithUser(
                                                user: data["user"],
                                                request: snapshots
                                                    .data!.docs[index].id),
                                      ));
                                },
                                icon: const Icon(Icons.check)),
                            IconButton(
                                onPressed: () {
                                  Future.delayed(
                                      const Duration(seconds: 0),
                                      () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return getAlertDialog(
                                                data["user"],
                                                snapshots.data!.docs[index].id,
                                                data["date"],
                                                data["time"]);
                                          }));
                                },
                                icon: const Icon(Icons.close)),
                          ],
                        ),
                        subtitle: Text(
                          "Problem:${data["problem"]}\nPreferred mode:${data['mode']}\nDominant Emotion:${data['emotion']}",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                      );
                    }),
              ],
            );
          }
        });
  }

  Widget getAlertDialog(
      String user, String requestid, String date, String time) {
    TextEditingController reasonController = TextEditingController();
    return AlertDialog(
      title: const Text("Mention reason for rejection"),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: reasonController,
              decoration: const InputDecoration(
                icon: Icon(Icons.question_answer),
                labelText: "Reason",
              ),
            ),
          ],
        );
      }),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            reasonController.text = "";

            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final notification = <String, String>{
              "message":
                  "Your request from $date at $time was denied on $dateTime at ${TimeOfDay.now().hour}:${TimeOfDay.now().minute}\n Reason:${reasonController.text}",
            };
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user)
                .collection("notifications")
                .doc(DateTime.now().toString())
                .set(notification)
                .then((value) async {
              await FirebaseFirestore.instance
                  .collection('counsellor')
                  .doc('counsellor@adcet.in')
                  .collection("Requests")
                  .doc(requestid)
                  .delete()
                  .then((value) {
                reasonController.text = "";
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const CounsellorPage()),
                    ModalRoute.withName(
                        '/') // Replace this with your root screen's route name (usually '/')
                    );
              });
            });
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
