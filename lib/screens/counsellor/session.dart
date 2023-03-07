import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/theme/Palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'addSession.dart';
// import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'startCall.dart';

class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  final TextEditingController _date = TextEditingController();
  final TextEditingController _timeStart = TextEditingController();
  final TextEditingController _timeEnd = TextEditingController();
  String? selectedAction;
  final String dateTime =
      "${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";
  TimeOfDay? tmd;
  // @override
  // void initState() {
  //   log("Date:$dateTime");
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
            backgroundColor: Palette.secondary,
            title: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Scheduled Sessions",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  // CircleAvatar(
                  //   backgroundColor: Palette.ternary[800],
                  //   child: IconButton(
                  //     // style:  const ButtonStyle(backgroundColor: Colors.orange),
                  //     icon: const Icon(
                  //       Icons.add_sharp,
                  //       color: Colors.white,
                  //     ),
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         // ignore: prefer_const_constructors
                  //         MaterialPageRoute(
                  //             builder: (context) => const AddSession()),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              )),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Today",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('counsellor')
                  .doc("counsellor@gmail.com")
                  .collection("session")
                  .where("date", isEqualTo: dateTime)
                  .orderBy("timeStart")
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshots.data!.size == 0) {
                  return const Center(
                    child: Text(
                      "You have no sessions today",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;
                        return Column(
                          children: [
                            ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              tileColor: Palette.tileback,
                              leading: const CircleAvatar(
                                backgroundColor: Palette.primary,
                                child: Text(
                                  "H",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                data['username'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "Start: ${data["timeStart"]} - End: ${data["timeEnd"]} ◾ Online",
                                // maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,

                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                              // isThreeLine: true,

                              trailing: PopupMenuButton<String>(
                                initialValue: selectedAction,
                                // Callback that sets the selected popup menu item.
                                onSelected: (String item) {
                                  setState(() {
                                    selectedAction = item;
                                  });
                                },

                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: "Start",
                                    child: const Text("Start"),
                                    onTap: () async {
                                      await Future.delayed(Duration.zero);
                                      if (!mounted) return;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Call(
                                                  id: snapshots
                                                      .data!.docs[index].id)));
                                    },
                                  ),
                                  PopupMenuItem<String>(
                                      value: "Postpone",
                                      child: const Text("Postpone"),
                                      onTap: () {
                                        Future.delayed(
                                          const Duration(seconds: 0),
                                          () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Postpone Session'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 130,
                                                      child: TextField(
                                                        controller: _date,
                                                        decoration:
                                                            const InputDecoration(
                                                          icon: Icon(Icons
                                                              .calendar_month),
                                                          labelText:
                                                              "Select a date",
                                                        ),
                                                        onTap: () async {
                                                          await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  firstDate:
                                                                      DateTime
                                                                          .now(),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2100))
                                                              .then(
                                                                  (pickedDate) {
                                                            if (pickedDate !=
                                                                null) {
                                                              setState(() {
                                                                _date.text =
                                                                    "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                                                              });
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: TextField(
                                                        controller: _timeStart,
                                                        decoration:
                                                            const InputDecoration(
                                                          icon: Icon(Icons
                                                              .access_time),
                                                          labelText:
                                                              "Start Time",
                                                        ),
                                                        onTap: () async {
                                                          await showTimePicker(
                                                            context: context,
                                                            initialTime: TimeOfDay
                                                                .fromDateTime(
                                                                    DateTime
                                                                        .now()),
                                                          ).then((pickedTime) {
                                                            if (pickedTime !=
                                                                null) {
                                                              if (validatePickedTime(
                                                                  pickedTime)) {
                                                                setState(() {
                                                                  _timeStart
                                                                          .text =
                                                                      "${pickedTime.hour.toString().padLeft(2, "0")}:${pickedTime.minute.toString().padLeft(2, "0")}";
                                                                  tmd =
                                                                      pickedTime;
                                                                });
                                                              } else {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Invalid Time");
                                                                _timeStart
                                                                    .text = "";
                                                              }
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: TextField(
                                                        controller: _timeEnd,
                                                        decoration:
                                                            const InputDecoration(
                                                          icon: Icon(Icons
                                                              .access_time_filled_sharp),
                                                          labelText: "End Time",
                                                        ),
                                                        onTap: () async {
                                                          await showTimePicker(
                                                            context: context,
                                                            initialTime: tmd!,
                                                          ).then((pickedTime) {
                                                            if (pickedTime !=
                                                                null) {
                                                              if (pickedTime.hour *
                                                                          60 +
                                                                      pickedTime
                                                                          .minute <=
                                                                  tmd!.hour *
                                                                          60 +
                                                                      tmd!.minute) {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Ending time cannot be earlier than starting time");
                                                              } else {
                                                                setState(() {
                                                                  _timeEnd.text =
                                                                      "${pickedTime.hour.toString().padLeft(2, "0")}:${pickedTime.minute.toString().padLeft(2, "0")}";
                                                                });
                                                              }
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      _date.text = _timeStart
                                                              .text =
                                                          _timeEnd.text = "";
                                                      Navigator.pop(
                                                          context, 'Cancel');
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (await validateSlot(
                                                          snapshots
                                                              .data!
                                                              .docs[index]
                                                              .id)) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'counsellor')
                                                            .doc(
                                                                'counsellor@gmail.com')
                                                            .collection(
                                                                'session')
                                                            .doc(snapshots.data!
                                                                .docs[index].id)
                                                            .update({
                                                          "date": _date.text,
                                                          "timeStart":
                                                              _timeStart.text,
                                                          "timeEnd":
                                                              _timeEnd.text
                                                        }).then((value) async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(data['user'])
                                                              .collection(
                                                                  'session')
                                                              .doc(snapshots
                                                                  .data!
                                                                  .docs[index]
                                                                  .id
                                                                  .toString())
                                                              .update({
                                                            "date": _date.text,
                                                            "timeStart":
                                                                _timeStart.text,
                                                            "timeEnd":
                                                                _timeEnd.text
                                                          }).then((value) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Modified successfully !");
                                                          });
                                                        });
                                                        _date.text = _timeStart
                                                                .text =
                                                            _timeEnd.text = "";
                                                        Navigator.pop(
                                                            context, 'OK');
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Invalid timeslot");
                                                      }
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                  PopupMenuItem<String>(
                                    value: "Cancel",
                                    child: const Text("Cancel"),
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection('counsellor')
                                          .doc('counsellor@gmail.com')
                                          .collection('session')
                                          .doc(snapshots.data!.docs[index].id
                                              .toString())
                                          .delete()
                                          .then((value) async {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(data['user'])
                                            .collection('session')
                                            .doc(snapshots.data!.docs[index].id
                                                .toString())
                                            .delete()
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg: "Session Cancelled");
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),

                              // leading: CircleAvatar(
                              //   backgroundImage: NetworkImage(data['image']),
                              // ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      });
                }
              },
            ),
            const Text("Later On"),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('counsellor')
                  .doc("counsellor@gmail.com")
                  .collection("session")
                  .where("date", isGreaterThan: dateTime)
                  .orderBy("date")
                  .orderBy("timeStart")
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshots.data!.size == 0) {
                  return const Center(
                    child: Text(
                      "No sessions are scheduled",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshots.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              tileColor: Palette.tileback,
                              leading: const CircleAvatar(
                                backgroundColor: Palette.primary,
                                child: Text(
                                  "H",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),

                              title: Text(
                                "${data['username']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${data['date']}  Start - ${data["timeStart"]} - ${data["timeEnd"]} ◾ OFFLINE",
                                // maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                              isThreeLine: true,
                              trailing: PopupMenuButton<String>(
                                initialValue: selectedAction,
                                // Callback that sets the selected popup menu item.
                                onSelected: (String item) {
                                  setState(() {
                                    selectedAction = item;
                                  });
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: "Modify",
                                    child: const Text("Modify"),
                                    onTap: () {
                                      {
                                        Future.delayed(
                                          const Duration(seconds: 0),
                                          () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Modify Session',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 130,
                                                      child: TextField(
                                                        controller: _date,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintStyle: TextStyle(
                                                              fontSize: 14),
                                                          icon: Icon(Icons
                                                              .calendar_month),
                                                          labelText:
                                                              "Select a date",
                                                        ),
                                                        onTap: () async {
                                                          await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  firstDate:
                                                                      DateTime
                                                                          .now(),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2100))
                                                              .then(
                                                                  (pickedDate) {
                                                            if (pickedDate !=
                                                                null) {
                                                              setState(() {
                                                                _date.text =
                                                                    "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                                                              });
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: TextField(
                                                        controller: _timeStart,
                                                        decoration:
                                                            const InputDecoration(
                                                          icon: Icon(Icons
                                                              .access_time),
                                                          labelText:
                                                              "Start Time",
                                                        ),
                                                        onTap: () async {
                                                          await showTimePicker(
                                                            context: context,
                                                            initialTime: TimeOfDay
                                                                .fromDateTime(
                                                                    DateTime
                                                                        .now()),
                                                          ).then((pickedTime) {
                                                            if (pickedTime !=
                                                                null) {
                                                              if (validatePickedTime(
                                                                  pickedTime)) {
                                                                setState(() {
                                                                  _timeStart
                                                                          .text =
                                                                      "${pickedTime.hour.toString().padLeft(2, "0")}:${pickedTime.minute.toString().padLeft(2, "0")}";
                                                                  tmd =
                                                                      pickedTime;
                                                                });
                                                              } else {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Invalid Time");
                                                                _timeStart
                                                                    .text = "";
                                                              }
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: TextField(
                                                        controller: _timeEnd,
                                                        decoration:
                                                            const InputDecoration(
                                                          icon: Icon(Icons
                                                              .access_time_filled_sharp),
                                                          labelText: "End Time",
                                                        ),
                                                        onTap: () async {
                                                          await showTimePicker(
                                                            context: context,
                                                            initialTime: tmd!,
                                                          ).then((pickedTime) {
                                                            if (pickedTime !=
                                                                null) {
                                                              if (pickedTime.hour *
                                                                          60 +
                                                                      pickedTime
                                                                          .minute <=
                                                                  tmd!.hour *
                                                                          60 +
                                                                      tmd!.minute) {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Ending time cannot be earlier than starting time");
                                                              } else {
                                                                setState(() {
                                                                  _timeEnd.text =
                                                                      "${pickedTime.hour.toString().padLeft(2, "0")}:${pickedTime.minute.toString().padLeft(2, "0")}";
                                                                });
                                                              }
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      _date.text = _timeStart
                                                              .text =
                                                          _timeEnd.text = "";
                                                      Navigator.pop(
                                                          context, 'Cancel');
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (await validateSlot(
                                                          snapshots
                                                              .data!
                                                              .docs[index]
                                                              .id)) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'counsellor')
                                                            .doc(
                                                                'counsellor@gmail.com')
                                                            .collection(
                                                                'session')
                                                            .doc(snapshots.data!
                                                                .docs[index].id)
                                                            .update({
                                                          "date": _date.text,
                                                          "timeStart":
                                                              _timeStart.text,
                                                          "timeEnd":
                                                              _timeEnd.text
                                                        }).then((value) async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(data['user'])
                                                              .collection(
                                                                  'session')
                                                              .doc(snapshots
                                                                  .data!
                                                                  .docs[index]
                                                                  .id
                                                                  .toString())
                                                              .update({
                                                            "date": _date.text,
                                                            "timeStart":
                                                                _timeStart.text,
                                                            "timeEnd":
                                                                _timeEnd.text
                                                          });
                                                        });
                                                        _date.text = _timeStart
                                                                .text =
                                                            _timeEnd.text = "";
                                                        Navigator.pop(
                                                            context, 'OK');
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Invalid time slot");
                                                      }
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  PopupMenuItem<String>(
                                    value: "Cancel",
                                    child: const Text("Cancel"),
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection('counsellor')
                                          .doc('counsellor@gmail.com')
                                          .collection('session')
                                          .doc(snapshots.data!.docs[index].id
                                              .toString())
                                          .delete()
                                          .then((value) async {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(data['user'])
                                            .collection('session')
                                            .doc(snapshots.data!.docs[index].id
                                                .toString())
                                            .delete()
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg: "Session Cancelled");
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                              // leading: CircleAvatar(
                              //   backgroundImage: NetworkImage(data['image']),
                              // ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      });
                }
              },
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            // ignore: prefer_const_constructors
            MaterialPageRoute(builder: (context) => const AddSession()),
          );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor: Palette.primary,
      ),
    );
  }

  bool validatePickedTime(TimeOfDay pickedTime) {
    if (pickedTime.hour * 60 + pickedTime.minute <
            DateTime.now().hour * 60 + DateTime.now().minute &&
        _date.text ==
            "${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}") {
      return false;
    }
    return true;
  }

  Future<bool> validateSlot(String id) async {
    int timeStart = int.parse(_timeStart.text.replaceAll(":", ""));
    int timeEnd = int.parse(_timeEnd.text.replaceAll(":", ""));
    final snapShot = await FirebaseFirestore.instance
        .collection('counsellor')
        .doc("counsellor@gmail.com")
        .collection("session")
        .where("date", isEqualTo: _date.text)
        .where('__name__', isNotEqualTo: id)
        .get();
    final List<DocumentSnapshot> documents = snapShot.docs;
    for (var doc in documents) {
      // log(doc.id.substring(8,12));
      // log(doc.id.substring(12,16));
      if (timeStart >
              int.parse(doc["timeStart"].toString().replaceAll(":", "")) &&
          timeStart <
              int.parse(doc["timeEnd"].toString().replaceAll(":", ""))) {
        log("Conflict with starting time");
        return false;
      }
      if (timeEnd >
              int.parse(doc["timeStart"].toString().replaceAll(":", "")) &&
          timeEnd < int.parse(doc["timeEnd"].toString().replaceAll(":", ""))) {
        log("Conflict with ending time");
        return false;
      }
      if (timeStart <
              int.parse(doc["timeStart"].toString().replaceAll(":", "")) &&
          timeEnd > int.parse(doc["timeEnd"].toString().replaceAll(":", ""))) {
        log("Schedule overlap");
        return false;
      }
    }

    return true;
  }

  // _joinMeeting() async {
  //
  //   //Map<FeatureFlag, Object> featureFlags = {};
  //
  //   // Define meetings options here
  //   var options = JitsiMeetingOptions(
  //     roomNameOrUrl: "adcetchat",
  //     // subject: subjectText.text,
  //     // token: tokenText.text,
  //     // isAudioMuted: isAudioMuted,
  //     // isAudioOnly: isAudioOnly,
  //     // isVideoMuted: isVideoMuted,
  //     // userDisplayName: userDisplayNameText.text,
  //     // userEmail: userEmailText.text,
  //     // featureFlags: featureFlags,
  //   );
  //
  //   log("JitsiMeetingOptions: $options");
  //   await JitsiMeetWrapper.joinMeeting(
  //     options: options,
  //     listener: JitsiMeetingListener(
  //       onOpened: () => log("onOpened"),
  //       onConferenceWillJoin: (url) {
  //         log("onConferenceWillJoin: url: $url");
  //       },
  //       onConferenceJoined: (url) {
  //         log("onConferenceJoined: url: $url");
  //       },
  //       onConferenceTerminated: (url, error) {
  //         Navigator.push(context,MaterialPageRoute(builder: (context)=>const Session()));
  //         log("onConferenceTerminated: url: $url, error: $error");
  //       },
  //       onAudioMutedChanged: (isMuted) {
  //         log("onAudioMutedChanged: isMuted: $isMuted");
  //       },
  //       onVideoMutedChanged: (isMuted){
  //         log("onVideoMutedChanged: isMuted: $isMuted");
  //       },
  //       onScreenShareToggled: (participantId, isSharing) {
  //         log(
  //           "onScreenShareToggled: participantId: $participantId, "
  //               "isSharing: $isSharing",
  //         );
  //       },
  //       onParticipantJoined: (email, name, role, participantId) {
  //         log(
  //           "onParticipantJoined: email: $email, name: $name, role: $role, "
  //               "participantId: $participantId",
  //         );
  //       },
  //       onParticipantLeft: (participantId) {
  //         log("onParticipantLeft: participantId: $participantId");
  //       },
  //       onParticipantsInfoRetrieved: (participantsInfo, requestId) {
  //         log(
  //           "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
  //               "requestId: $requestId",
  //         );
  //       },
  //       onChatMessageReceived: (senderId, message, isPrivate) {
  //         log(
  //           "onChatMessageReceived: senderId: $senderId, message: $message, "
  //               "isPrivate: $isPrivate",
  //         );
  //       },
  //       onChatToggled: (isOpen) => log("onChatToggled: isOpen: $isOpen"),
  //       onClosed:() {
  //         log("onClosed");
  //
  //         },
  //
  //     ),
  //   );
  // }
}
