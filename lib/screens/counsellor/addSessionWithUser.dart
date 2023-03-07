import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'counsellorPage.dart';

class AddSessionWithUser extends StatefulWidget {
  const AddSessionWithUser({Key? key, required this.user, required this.request})
      : super(key: key);
  final String user;
  final String request;
  @override
  State<AddSessionWithUser> createState() => _AddSessionWithUserState();
}

class _AddSessionWithUserState extends State<AddSessionWithUser> {
  final TextEditingController _date = TextEditingController();
  final TextEditingController _timeStart = TextEditingController();
  final TextEditingController _timeEnd = TextEditingController();
  final TextEditingController _agenda = TextEditingController();
  DateTime dateTime = DateTime.now();
  bool selectedMode = true;
  String mode = "Online";
  String user = "";
  String request = "";
  String username = "";
  @override
  void initState() {
    user = widget.user;
    request = widget.request;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .get()
        .then((value) {
      username = value.data()!["name"];
      log(username);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "New Session",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  style: const TextStyle(fontSize: 14),
                  controller: _date,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_month),
                    labelText: "Select a date",

                  ),
                  onTap: () async {
                    await showDatePicker(
                            context: context,
                            initialDate: dateTime,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100))
                        .then((pickedDate) {
                      if (pickedDate != null) {
                        setState(() {
                          _date.text =
                              "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                          dateTime = DateTime(pickedDate.year, pickedDate.month,
                              pickedDate.day, dateTime.hour, dateTime.minute);
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextField(
                        style: const TextStyle(fontSize: 14),
                        controller: _timeStart,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.access_time),
                          labelText: "Start Time",
                        ),
                        onTap: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(dateTime),
                          ).then((pickedTime) {
                            if (pickedTime != null) {
                              setState(() {
                                _timeStart.text =
                                    "${pickedTime.hour.toString().padLeft(2, "0")}:${pickedTime.minute.toString().padLeft(2, "0")}";
                                dateTime = DateTime(
                                    dateTime.year,
                                    dateTime.month,
                                    dateTime.day,
                                    pickedTime.hour,
                                    pickedTime.minute);
                              });
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _timeEnd,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.access_time_filled_sharp),
                          labelText: "End Time",
                        ),
                        onTap: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                dateTime.add(const Duration(minutes: 30))),
                          ).then((pickedTime) {
                            if (pickedTime != null) {
                              setState(() {
                                _timeEnd.text =
                                "${pickedTime.hour.toString().padLeft(2, "0")}:${pickedTime.minute.toString().padLeft(2, "0")}";
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ]),
                const SizedBox(height: 20,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "User: $user",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(mode),
                  Switch(
                      value: selectedMode,
                      onChanged: (bool value) {
                        setState(() {
                          selectedMode = value;
                          mode = value ? "Online" : "Offline";
                          log(selectedMode.toString());
                        });
                      }),
                ]),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(fontSize: 14),
                  controller: _agenda,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.golf_course),
                    labelText: "Agenda of the session",
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          final session = <String, String>{
                            "date": _date.text,
                            "timeStart": _timeStart.text,
                            "timeEnd": _timeEnd.text,
                            "user": user,
                            "username": username,
                            "agenda": _agenda.text,
                            "mode": selectedMode ? "Online" : "Offline",
                          };
                          final dt = DateTime(dateTime.year, dateTime.month,
                              dateTime.day, dateTime.hour)
                              .toString()
                              .substring(0, 10)
                              .replaceAll("-", "");
                          final docId =
                              "$dt${_timeStart.text.replaceAll(":", "")}${_timeEnd.text.replaceAll(":", "")}";

                          if (await validate(docId, session)) {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(user)
                                .collection("session")
                                .doc(docId)
                                .set(session);
                            await FirebaseFirestore.instance
                                .collection("counsellor")
                                .doc("counsellor@gmail.com")
                                .collection("session")
                                .doc(docId)
                                .set(session);
                            Fluttertoast.showToast(
                                msg: "Session added successfully");
                            if (request == "") {
                              if (!mounted) return;
                              Navigator.pop(context);
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('counsellor')
                                  .doc('counsellor@gmail.com')
                                  .collection("Requests")
                                  .doc(request)
                                  .delete()
                                  .then((value) async {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user)
                                    .update({"requested": false});
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
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "This time is not available");
                          }
                        },
                        child: const Text("Add")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                  ],
                )
                ],
              ),
          ),
        )
    );
  }

  Future<bool> validate(String docId, Map<String, String> session) async {
    final start = int.parse(docId.substring(08, 12));
    final end = int.parse(docId.substring(12, 16));
    // log(docId);
    final snapShot = await FirebaseFirestore.instance
        .collection('counsellor')
        .doc("counsellor@gmail.com")
        .collection("session")
        .where("date", isEqualTo: session["date"])
        .get();
    final List<DocumentSnapshot> documents = snapShot.docs;
    for (var doc in documents) {
      // log(doc.id.substring(8,12));
      // log(doc.id.substring(12,16));
      if (start > int.parse(doc["timeStart"].toString().replaceAll(":", "")) &&
          start < int.parse(doc["timeEnd"].toString().replaceAll(":", ""))) {
        log("Conflict with starting time");
        return false;
      }
      if (end > int.parse(doc["timeStart"].toString().replaceAll(":", "")) &&
          end < int.parse(doc["timeEnd"].toString().replaceAll(":", ""))) {
        log("Conflict with ending time");
        return false;
      }
      if (start < int.parse(doc["timeStart"].toString().replaceAll(":", "")) &&
          end > int.parse(doc["timeEnd"].toString().replaceAll(":", ""))) {
        log("Schedule overlap");
        return false;
      }
    }

    return true;
  }
}
