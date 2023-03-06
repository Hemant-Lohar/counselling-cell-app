import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'quiz_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/user/userProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final String username = FirebaseAuth.instance.currentUser!.email!;
  String initial = "";
  String name = "";
  late final String dateTime;
  bool showAssessment = false;
  bool showRequestButton = true;
  bool selectedMode = true;
  String mode = "Online";
  bool firstSession = false;
  String first = "No";
  final TextEditingController _problemController = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(username)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        showAssessment = data["assessment"];
        showRequestButton = !data["requested"];
        firstSession=data["firstTime"];
        name = data["name"];
        initial = username[0].toUpperCase();
      });
    });
    dateTime =
        "${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hi, $name',
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.notifications, color: Colors.black,),onPressed: (){

            },),
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
                    backgroundColor: const Color.fromARGB(255, 51, 51, 51),
                    child: Text(
                      initial,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )),

          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              showAssessment ? getAssessmentButton() : getSessions(),
            ],
          ),
        ));
  }

  Widget getAssessmentButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Welcome User, Take a short assessment to improve your experience",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              final cameraList = await availableCameras();
              final x = cameraList.last;
              setState(() {
                Navigator.push(
                  context,
                  // ignore: prefer_const_constructors
                  MaterialPageRoute(
                      builder: (context) => QuizScreen(camera: x)),
                );
              });
            },
            child: const Text("Take Assessment")),
      ],
    );
  }

  Widget getSessions() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(username)
            .collection("session")
            .where("date", isGreaterThanOrEqualTo: dateTime)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshots.data!.size == 0) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "You have no appointments scheduled !!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  showRequestButton?ElevatedButton(
                      onPressed: () {
                        Future.delayed(
                            const Duration(seconds: 0),
                            () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return getAlertDialog();
                                }));
                      },
                      child: const Text("Request an appointment")):Container(),
                ]);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Your upcoming session",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
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
                          data['date'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        trailing: Text(
                          "${data["timeStart"]}-${data["timeEnd"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          data['mode'],
                          maxLines: 1,
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

  Widget getAlertDialog() {
    return AlertDialog(
      title: const Text('Mention your problems in short'),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: _problemController,
              decoration: const InputDecoration(
                icon: Icon(Icons.warning),
                labelText: "Problem",
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Preferred mode:    $mode")),
              Switch(
                  value: selectedMode,
                  onChanged: (bool value) {
                    setState(() {
                      selectedMode = value;
                      mode = value ? "Online" : "Offline";
                      //log(selectedMode.toString());
                    });
                  }),
            ]),
            Container(
                padding: const EdgeInsets.all(3.0),
                child: const Text("Is this your first interaction:")),
          ],
        );
      }),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            _problemController.text = "";
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final request = <String, String>{
              "user": username,
              "name": name,
              "problem": _problemController.text,
              "mode": mode,
              "firstTime": firstSession ? "true" : "false"
            };
            final docId = DateTime.now().toString();
            await FirebaseFirestore.instance
                .collection("counsellor")
                .doc("counsellor@gmail.com")
                .collection("Requests")
                .doc(docId)
                .set(request)
                .then((value) async {
              _problemController.text = "";
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(username)
                  .update({
                "requested": true,
                "firstTime": false
              }).then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const UserPage()),
                    ModalRoute.withName('/') // Replace this with your root screen's route name (usually '/')
                );
                Fluttertoast.showToast(msg: "Request sent successfully\nYou will be notified when your request is updated !",toastLength: Toast.LENGTH_LONG);
              });
            });
          },
          child: const Text('Send Request'),
        ),
      ],
    );
  }
}
