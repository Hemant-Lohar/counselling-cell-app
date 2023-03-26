import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/user/assesment/quiz_screen.dart';
import 'package:counselling_cell_application/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:camera/camera.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import '../user/userPage.dart';
import 'package:universal_html/html.dart' as html;

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  bool isAudioMuted = true;
  bool isAudioOnly = false;
  bool isVideoMuted = true;
  final String username = FirebaseAuth.instance.currentUser!.email!;
  String initial = "";
  String name = "";
  late final String dateTime;
  bool showAssessment = true;
  bool showRequestButton = false;
  bool selectedMode = true;
  String mode = "Online";
  bool firstSession = false;
  String first = "No";
  String emotion = "";
  final TextEditingController _problemController = TextEditingController();
  String? selectedAction;

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(username)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        showAssessment = data["assessment"];
        firstSession = data["firstTime"];
        name = data["name"];
        emotion = data["emotion"];
        initial = username[0].toUpperCase();
      });
    });
    setShowButton();
    dateTime =
        "${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
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
                   showRequestButton
                  ?ElevatedButton(
                          onPressed: () {
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return getAlertDialog();
                                    }));
                          },
                          child: const Text("Request an appointment")): Container(),
                ]);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Your upcoming session",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
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
                          DateFormat('dd/MM/yyyy').format(DateFormat('yyyy/MM/dd').parse(data["date"])),
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
                            Text(
                              "${data["timeStart"]}-${data["timeEnd"]}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: () async {
                                await Future.delayed(Duration.zero);
                                if (!mounted) return;
                                Fluttertoast.showToast(msg: "Calling..");
                                if (kIsWeb) {
                                  html.window.open(
                                      "https://meet.jit.si/CounsellingCell",
                                      "Ongoing Session");
                                } else {
                                  _joinMeeting();
                                }
                              },
                              icon: const Icon(Icons.call),
                              color: Palette.primary,
                            )
                          ],
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

  Widget getAssessmentButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
              if(kIsWeb){
                Fluttertoast.showToast(msg: "Use mobile version to give assessment");
              }
              else{
                // final cameraList = await availableCameras();
                // final x = cameraList.last;
                // setState(() {
                //   Navigator.push(
                //     context,
                //     // ignore: prefer_const_constructors
                //     MaterialPageRoute(
                //         builder: (context) => QuizScreen(camera: x)),
                //   );
                // });
              }

            },
            child: const Text("Take Assessment")),
      ],
    );
  }

  Widget getAlertDialog() {
    return AlertDialog(
      title: const Text('Mention your problems in short',
          style: TextStyle(fontSize: 18)),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              style: const TextStyle(fontSize: 14),
              keyboardType: TextInputType.text,
              controller: _problemController,
              decoration: const InputDecoration(
                icon: Icon(Icons.question_answer),
                labelText: "Problem",
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Preferred mode:    $mode",
                style: const TextStyle(fontSize: 14),
              ),
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
              "date": dateTime,
              "time": "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
              "firstTime": firstSession ? "true" : "false",
              "emotion": emotion
            };
            final docId = DateTime.now().toString();
            await FirebaseFirestore.instance
                .collection("counsellor")
                .doc("counsellor@adcet.in")
                .collection("Requests")
                .doc(docId)
                .set(request)
                .then((value) async {
              _problemController.text = "";
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(username)
                  .update({"firstTime": false}).then(
                      (value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UserPage()),
                    ModalRoute.withName(
                        '/') // Replace this with your root screen's route name (usually '/')
                    );
                Fluttertoast.showToast(
                    msg:
                        "Request sent successfully\nYou will be notified when your request is updated !",
                    toastLength: Toast.LENGTH_LONG);
              });
            });
          },
          child: const Text('Send Request'),
        ),
      ],
    );
  }
  _joinMeeting() async {
    Map<FeatureFlag, Object> featureFlags = {
      FeatureFlag.isConferenceTimerEnabled: false,
      FeatureFlag.isCalendarEnabled: false,
      FeatureFlag.isAddPeopleEnabled: false,
      FeatureFlag.isCloseCaptionsEnabled: false,
      FeatureFlag.areSecurityOptionsEnabled: false,
      FeatureFlag.isNotificationsEnabled: false,
      FeatureFlag.isRaiseHandEnabled: false
    };
    // Define meetings options here

    String name = FirebaseAuth.instance.currentUser!.email!;
    var options = JitsiMeetingOptions(
      roomNameOrUrl: "CounsellingCell",
      //subject: ,
      isAudioMuted: true,
      isAudioOnly: false,
      isVideoMuted: true,
      userEmail: name,
      userDisplayName: username,
      featureFlags: featureFlags,
    );

    log("JitsiMeetingOptions: $options");
    try {
      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () => log("onOpened"),
          onConferenceWillJoin: (url) {
            log("onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            log("onConferenceJoined: url: $url");
          },
          onConferenceTerminated: (url, error) {
            log("onConferenceTerminated: url: $url, error: $error");
            JitsiMeetWrapper.hangUp();
          },
          onAudioMutedChanged: (isMuted) {
            log("onAudioMutedChanged: isMuted: $isMuted");
          },
          onVideoMutedChanged: (isMuted) {
            log("onVideoMutedChanged: isMuted: $isMuted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            log(
              "onScreenShareToggled: participantId: $participantId, "
                  "isSharing: $isSharing",
            );
          },
          onParticipantJoined: (email, name, role, participantId) {
            log(
              "onParticipantJoined: email: $email, name: $name, role: $role, "
                  "participantId: $participantId",
            );
          },
          onParticipantLeft: (participantId) {
            log("onParticipantLeft: participantId: $participantId");
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {
            log(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
                  "requestId: $requestId",
            );
          },
          onChatMessageReceived: (senderId, message, isPrivate) {
            log(
              "onChatMessageReceived: senderId: $senderId, message: $message, "
                  "isPrivate: $isPrivate",
            );
          },
          onChatToggled: (isOpen) => log("onChatToggled: isOpen: $isOpen"),
          onClosed: () => log("onClosed"),
        ),
      );
    } catch (error) {
      log(error.toString());
    }
  }

  void setShowButton()async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("counsellor").doc("counsellor@adcet.in").collection("Requests").where("user",isEqualTo: username).get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    log("Total number of requests : ${documents.length}");
    setState(() {
      showRequestButton = documents.isEmpty;
    });
  }
}









// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../login/loginPage.dart';

// class userHomePage extends StatefulWidget {
//   final User user;
//   const userHomePage({
//     super.key,
//     required this.user,
//   });
//   @override
//   _userHomePageState createState() => _userHomePageState(this.user);
// }
// class _userHomePageState extends State<userHomePage> {
//   User user;
//   late String username= user.email.toString();
//   _userHomePageState(this.user);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Homepage for user",
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.grey,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(36.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//                Text("Welcome $username !\nThis is Your Homepage.",
//                   style:const  TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30)),
//               ElevatedButton(
//                   onPressed: () {

//                   }, child: const Text("Video calling demo")),
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
//                 style: const TextStyle(color: Colors.black, fontSize: 20),
//               ),
//             ),
//             ListTile(
//               title: const Text('Sessions'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Recommendation'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Prescriptions'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer

//                 Navigator.pop(context);
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
//                   MaterialPageRoute(builder: (context) => const LoginPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
