import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/counsellor/counsellorHomePage.dart';
import 'package:counselling_cell_application/screens/counsellor/session.dart';
import 'package:counselling_cell_application/theme/palette.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'dart:io';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'counsellorPage.dart';

class Call extends StatefulWidget {
  const Call({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  String id = "";
  String user = "";
  String name = "";
  int num = 0;
  bool isAudioMuted = true;
  bool isAudioOnly = false;
  bool isVideoMuted = true;
  final _observationController = TextEditingController();
  final _newIssuesController = TextEditingController();
  final _detailsController = TextEditingController();
  final _timeEndController = TextEditingController();
  @override
  void initState() {
    super.initState();
    id = widget.id;
    log(id);
    FirebaseFirestore.instance
        .collection("counsellor")
        .doc("counsellor@adcet.in")
        .collection("session")
        .doc(id)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        user = data["user"];
        name = data["username"];
        log(user.toString());
        FirebaseFirestore.instance
            .collection("users")
            .doc(user)
            .get()
            .then((DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            num = data["sessionCount"];
            log(num.toString());
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session in Progress"),
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: buildMeetConfig(),
      ),
    );
  }

  Widget buildMeetConfig() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16.0),
          // _buildTextField(
          //   labelText: "Server URL",
          //   controller: serverText,
          //   hintText: "Hint: Leave empty for meet.jitsi.si",
          // ),
          // const SizedBox(height: 16.0),
          // _buildTextField(labelText: "Room", controller: roomText),
          // const SizedBox(height: 16.0),
          // _buildTextField(labelText: "Subject", controller: subjectText),
          // const SizedBox(height: 16.0),
          // _buildTextField(labelText: "Token", controller: tokenText),
          // const SizedBox(height: 16.0),
          // _buildTextField(
          //   labelText: "User Display Name",
          //   controller: userDisplayNameText,
          // ),
          // const SizedBox(height: 16.0),
          // _buildTextField(
          //   labelText: "User Email",
          //   controller: userEmailText,
          // ),
          // const SizedBox(height: 16.0),
          // _buildTextField(
          //   labelText: "User Avatar URL",
          //   controller: userAvatarUrlText,
          // ),
          // const SizedBox(height: 16.0),
          // CheckboxListTile(
          //   title: const Text("Audio Muted"),
          //   value: isAudioMuted,
          //   onChanged: _onAudioMutedChanged,
          // ),
          // const SizedBox(height: 16.0),
          // CheckboxListTile(
          //   title: const Text("Audio Only"),
          //   value: isAudioOnly,
          //   onChanged: _onAudioOnlyChanged,
          // ),
          // const SizedBox(height: 16.0),
          // CheckboxListTile(
          //   title: const Text("Video Muted"),
          //   value: isVideoMuted,
          //   onChanged: _onVideoMutedChanged,
          // ),
          // const Divider(height: 48.0, thickness: 2.0),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                if (kIsWeb) {
                  html.window.open(
                      "https://meet.jit.si/CounsellingCell", "Ongoing Session");
                } else {
                  _joinMeeting();
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Palette.secondary),
              ),
              child: const Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 48.0),
          Center(
            child: Text(
              "User: $name",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _observationController,
              decoration: const InputDecoration(
                icon: Icon(Icons.receipt),
                labelText: "Observations",
              ),
            ),
          ),
          const SizedBox(height: 60.0),
          SizedBox(
            width: double.maxFinite,
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _newIssuesController,
              decoration: const InputDecoration(
                icon: Icon(Icons.medical_services),
                labelText: "New Issues",
              ),
            ),
          ),
          const SizedBox(height: 60.0),
          SizedBox(
            width: double.maxFinite,
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _detailsController,
              decoration: const InputDecoration(
                icon: Icon(Icons.medical_services),
                labelText: "Session details",
              ),
            ),
          ),
          const SizedBox(height: 60.0),
          SizedBox(
            child: TextField(
              controller: _timeEndController,
              decoration: const InputDecoration(
                icon: Icon(Icons.access_time_filled_sharp),
                labelText: "End Time",
              ),
              onTap: () async {
                await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((pickedTime) {
                  if (pickedTime != null) {
                    setState(() {
                      _timeEndController.text =
                          "${pickedTime.hour.toString().padLeft(2, "0")}:${pickedTime.minute.toString().padLeft(2, "0")}";
                    });
                  }
                });
              },
            ),
          ),
          const SizedBox(height: 60.0),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("counsellor")
                    .doc("counsellor@adcet.in")
                    .collection("session")
                    .doc(id)
                    .get()
                    .then((DocumentSnapshot doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  data.addAll({
                    "observation": _observationController.text,
                    "new_issues": _newIssuesController.text,
                    "details": _detailsController.text,
                    "timeEnd": _timeEndController.text,
                    "sessionNumber": num++
                  });
                  FirebaseFirestore.instance
                      .collection("counsellor")
                      .doc("counsellor@adcet.in")
                      .collection("completedSession")
                      .doc(id)
                      .set(data)
                      .onError((error, stackTrace) {
                    Fluttertoast.showToast(msg: "An error has occurred");
                  });
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .collection("completedSession")
                      .doc(id)
                      .set(data)
                      .onError((error, stackTrace) {
                    Fluttertoast.showToast(msg: "An error has occurred");
                  });
                });
                FirebaseFirestore.instance.collection("users").doc(user).update(
                    {"sessionCount": num++}).onError((error, stackTrace) {
                  Fluttertoast.showToast(msg: "An error has occurred");
                });
                FirebaseFirestore.instance
                    .collection("counsellor")
                    .doc("counsellor@adcet.in")
                    .collection("session")
                    .doc(id)
                    .delete()
                    .onError((error, stackTrace) {
                  Fluttertoast.showToast(msg: "An error has occurred");
                });
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user)
                    .collection("session")
                    .doc(id)
                    .delete()
                    .onError((error, stackTrace) {
                  Fluttertoast.showToast(msg: "An error has occurred");
                });

                Fluttertoast.showToast(msg: "Session data is saved");
                _observationController.text = "";
                _newIssuesController.text = "";
                _detailsController.text = "";
                _timeEndController.text = "";
                if (!mounted) return;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Palette.secondary),
              ),
              child: const Text(
                "Conclude Session",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value!;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
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
    var options = JitsiMeetingOptions(
      roomNameOrUrl: "CounsellingCell",
      subject: "Agenda",
      isAudioMuted: isAudioMuted,
      isAudioOnly: isAudioOnly,
      isVideoMuted: isVideoMuted,
      userDisplayName: "counsellor",
      userEmail: "counsellor@adcet.in",
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

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText),
    );
  }
}
