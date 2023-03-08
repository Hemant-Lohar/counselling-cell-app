import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSession extends StatefulWidget {
  const AddSession({Key? key}) : super(key: key);

  @override
  State<AddSession> createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  final TextEditingController _date = TextEditingController();
  final TextEditingController _timeStart = TextEditingController();
  final TextEditingController _timeEnd = TextEditingController();
  final TextEditingController _agenda = TextEditingController();
  DateTime dateTime = DateTime.now();
  bool selectedMode = true; // true->online , false->offline
  String mode = "Online";
  static String selectUser(String option) => option;
  String selectedUser = "";
  String userid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white, // <-- SEE HERE
          ),
          title: const Text(
            "Add Session",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 350,
                  child: TextField(
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
                            dateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                dateTime.hour,
                                dateTime.minute);
                          });
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
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
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        style: const TextStyle(fontSize: 14),
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
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(
                        mode,
                        style: const TextStyle(fontSize: 14),
                      ),
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "User:  ",
                            style: TextStyle(fontSize: 14),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text("No data available");
                              } else {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  List<String> users = [];
                                  Map<String, String> userlist = {};
                                  for (int i = 0;
                                      i < snapshot.data!.docs.length;
                                      i++) {
                                    DocumentSnapshot snap =
                                        snapshot.data!.docs[i];
                                    users.add(snap["name"]);
                                    userlist[snap['name']] = snap['id'];
                                  }
                                  return SizedBox(
                                    width: 150,
                                    height: 75,
                                    child: Autocomplete(
                                      displayStringForOption: selectUser,
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<String>.empty();
                                        }
                                        return users.where((String option) {
                                          return option.toLowerCase().contains(
                                              textEditingValue.text
                                                  .toLowerCase());
                                        });
                                      },
                                      onSelected: (String user) {
                                        // setState(() {
                                        //   selectedUser = User;
                                        //   userid = userlist[User].toString();
                                        //   log("$selectedUser $userid");
                                        // });
                                        selectedUser = user;
                                        userid = userlist[user].toString();
                                        log("$selectedUser $userid");
                                      },
                                    ),
                                  );
                                  // return DropdownButton<dynamic>(
                                  //   items: users,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       selectedUser = value;
                                  //       username=userlist[value]!;
                                  //       log(value);
                                  //       log(username);
                                  //     });
                                  //   },
                                  //   value: selectedUser,
                                  //   hint: const Text(
                                  //     "Select a user",
                                  //   ),
                                  // );
                                }
                              }
                            },
                          ),
                        ])
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    keyboardType: TextInputType.text,
                    controller: _agenda,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.golf_course),
                      labelText: "Agenda of the session",
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final session = <String, String>{
                            "date": _date.text,
                            "timeStart": _timeStart.text,
                            "timeEnd": _timeEnd.text,
                            "user": userid,
                            "username": selectedUser,
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
                                .doc(userid)
                                .collection("session")
                                .doc(docId)
                                .set(session);
                            await FirebaseFirestore.instance
                                .collection("counsellor")
                                .doc("counsellor@adcet.in")
                                .collection("session")
                                .doc(docId)
                                .set(session);
                            Fluttertoast.showToast(
                                msg: "Session added successfully");

                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                                msg: "This time is not available");
                          }
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> validate(String docId, Map<String, String> session) async {
    final start = int.parse(docId.substring(08, 12));
    final end = int.parse(docId.substring(12, 16));
    // log(docId);
    final snapShot = await FirebaseFirestore.instance
        .collection('counsellor')
        .doc("counsellor@adcet.in")
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
