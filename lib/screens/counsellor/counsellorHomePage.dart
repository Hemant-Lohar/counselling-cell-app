import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addSessionWithUser.dart';
import 'counsellorPage.dart';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  String initial="";
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
                    backgroundColor: Colors.black,
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
              child: Column(children: [
                Text("Welcome $name !\nThis is Your Homepage.",
                    style: const TextStyle(color: Colors.black, fontSize: 16)),
                const SizedBox(
                  height: 30,
                ),
                getNewRequests(),
                getRequests()
                // ElevatedButton(onPressed: () async{
                //
                // }, child: const Text("Send"))
              ]),
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
                      "You have no requests from existing users!!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
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
                    fontSize: 20,
                    color: Colors.black,
                  ),
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
                                            return getAlertDialog(data["user"],
                                                snapshots.data!.docs[index].id);
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
                      "You have no new requests!!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
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
                    color: Colors.black,
                    fontSize: 20,
                    // fontWeight: FontWeight.bold
                  ),
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
                                            return getAlertDialog(data["user"],
                                                snapshots.data!.docs[index].id);
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

  Widget getAlertDialog(String user, String requestid) {
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
              "message": "Your request was denied.",
              "reason": reasonController.text
            };
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user)
                .collection("notifications")
                .doc(DateTime.now().toString())
                .set(notification)
                .then((value) async {
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(username)
                  .update({
                "requested": false,
              });
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


// import 'package:counselling_cell_application/screens/counsellor/addUser.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';

// import '../login/loginPage.dart';
// import 'userList.dart';

// class counsellorHomePage extends StatefulWidget {
//   final User user;
//   const counsellorHomePage({
//     super.key,
//     required this.user,
//   });
//   @override
//   _counsellorHomePageState createState() => _counsellorHomePageState(this.user);
// }

// class _counsellorHomePageState extends State<counsellorHomePage> {
//   User user;
//   late String username= user.email.toString();
//   _counsellorHomePageState(this.user);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Homepage for counsellor",
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.grey,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(36.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//                Text("Welcome $username !\nThis is Your Homepage.",
//                   style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30)),
//               const SizedBox(
//                 height: 30,
//               ),
//               ElevatedButton(onPressed: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AddUser()),
//                 );

//               }, child: const Text("Add new user",style:TextStyle(
//                 fontSize: 20,
//               ),)),
//             ],
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         // Add a ListView to the drawer. This ensures the user can scroll
//         // through the options in the drawer if there isn't enough vertical
//         // space to fit everything.
//         child: ListView(
//           // Important: Remove any padding from the ListView.
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: Text(
//                 username,
//                 textAlign: TextAlign.justify,
//                 style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 20
//                 ),
//               ),
//             ),
//             ListTile(
//               title: const Text('Reports'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Events'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Users'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer

//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const UserList()),
//                 );
//               },
//             ),
//             ListTile(
//               title: const Text('Logout'),
//               onTap: () {
//                 Navigator.popUntil(
//                   context,
//                   ModalRoute.withName('/'),
//                 );
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const LoginPage()),
//                 );

//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
