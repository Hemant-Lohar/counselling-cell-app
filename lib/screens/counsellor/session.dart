import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_html/html.dart' as html;
import 'package:intl/intl.dart';
import 'package:counselling_cell_application/theme/Palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:path/path.dart';
import 'addSession.dart';
// import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'pdfAPI.dart';
import 'startCall.dart';
import 'pdfAnalytics.dart';

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
  String id = FirebaseAuth.instance.currentUser!.email!;
  var anchor;
  final String dateTime =
      "${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";
  TimeOfDay? tmd;

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
              ],
            )),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  Future.delayed(
                    const Duration(seconds: 0),
                    () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return analyticDialog();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.download))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Missed Sessions",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("counsellor")
                  .doc("counsellor@adcet.in")
                  .collection("session")
                  .where("date", isLessThanOrEqualTo:DateFormat('yyyy/MM/dd').format(DateFormat('dd/MM/yyyy').parse(dateTime)))
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshots.data!.size == 0) {
                  return const Center(
                    child: Text(
                      "You did not miss any sessions ! Keep it going",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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
                        // log(data.toString());
                        // log(DateFormat('yyyy/MM/dd').format(DateFormat('dd/MM/yyyy').parse(dateTime)));
                        // log("${TimeOfDay.now().hour}${TimeOfDay.now().minute}");
                        // log(int.parse(data["timeStart"].toString().replaceAll(":", "")).toString());
                        return ( data["date"].toString().compareTo( DateFormat('yyyy/MM/dd').format(DateFormat('dd/MM/yyyy').parse(dateTime)))<0 || int.parse(data["timeStart"].toString().replaceAll(":", ""))< int.parse("${TimeOfDay.now().hour.toString().padLeft(2, "0")}${TimeOfDay.now().minute.toString().padLeft(2, "0")}"))?
                         Column(
                          children: [
                            ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              tileColor: Palette.tileback,
                              leading: CircleAvatar(
                                backgroundColor: Palette.primary,
                                child: Text(
                                  data['username']![0].toString().toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
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
                                "${DateFormat('dd/MM/yyyy').format(DateFormat('yyyy/MM/dd').parse(data["date"]))}\n Start: ${data["timeStart"]} - End: ${data["timeEnd"]} ◾ ${data["mode"]}",
                                 maxLines: 2,
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
                                      value: "Postpone",
                                      child: const Text("Postpone"),
                                      onTap: () {
                                        Future.delayed(
                                          const Duration(seconds: 0),
                                          () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return postponeDialog(context,snapshots.data!
                                                  .docs[index].id,data["user"],data["date"],data["timeStart"]);
                                            },
                                          ),
                                        );
                                      }),
                                  PopupMenuItem<String>(
                                    value: "Cancel",
                                    child: const Text("Cancel"),
                                    onTap: () {
                                      cancelSession(snapshots.data!.docs[index].id,data['user'],data["date"],data["timeStart"]);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        )
                        :Container();
                      });
                }
              },
            ),
            const Text("Today", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('counsellor')
                  .doc("counsellor@adcet.in")
                  .collection("session")
                  .where(
                    "date",
                    isEqualTo: DateFormat('yyyy/MM/dd')
                        .format(DateFormat('dd/MM/yyyy').parse(dateTime)),
                  )
                  // .where("timeStart",
                  //     isGreaterThanOrEqualTo:
                  //         "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}")
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
                        color: Colors.grey,
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
                        // log(data.toString());
                        // log(DateFormat('yyyy/MM/dd').format(DateFormat('dd/MM/yyyy').parse(dateTime)));

                        return
                          Column(
                          children: [
                            ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              tileColor: Palette.tileback,
                              leading: CircleAvatar(
                                backgroundColor: Palette.primary,
                                child: Text(
                                  data['username']![0].toString().toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
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
                                "Start: ${data["timeStart"]} - End: ${data["timeEnd"]} ◾ ${data["mode"]}",
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
                                              return postponeDialog(context,snapshots.data!
                                                  .docs[index].id,data["user"],data["date"],data["timeStart"]);
                                            },
                                          ),
                                        );
                                      }),
                                  PopupMenuItem<String>(
                                    value: "Cancel",
                                    child: const Text("Cancel"),
                                    onTap: () {
                                      cancelSession(snapshots.data!.docs[index].id,data['user'],data["date"],data["timeStart"]);

                                    },
                                  ),
                                ],
                              ),
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
            const SizedBox(
              height: 10,
            ),
            const Text("Later On", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('counsellor')
                  .doc("counsellor@adcet.in")
                  .collection("session")
                  .where("date",
                      isGreaterThan: DateFormat('yyyy/MM/dd')
                          .format(DateFormat('dd/MM/yyyy').parse(dateTime)))
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
                        color: Colors.grey,
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
                              leading: CircleAvatar(
                                backgroundColor: Palette.primary,
                                child: Text(
                                  data['username']![0].toString().toUpperCase(),
                                  style: const TextStyle(
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
                                "${DateFormat('dd/MM/yyyy').format(DateFormat('yyyy/MM/dd').parse(data["date"]))}  Start - ${data["timeStart"]} - ${data["timeEnd"]} ◾ ${data["mode"]}",
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
                                              return postponeDialog(context,snapshots.data!
                                                  .docs[index].id,data["user"],data["date"],data["timeStart"]);
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  PopupMenuItem<String>(
                                    value: "Cancel",
                                    child: const Text("Cancel"),
                                    onTap: () {
                                      cancelSession(snapshots.data!.docs[index].id,data['user'],data["date"],data["timeStart"]);
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
        .doc("counsellor@adcet.in")
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

  Widget analyticDialog() {
    return AlertDialog(
      title: const Text("Select Time Frame"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: TextField(
              style: const TextStyle(fontSize: 14),
              controller: _timeStart,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_month),
                labelText: "Select start date",
              ),
              onTap: () async {
                await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2100))
                    .then((pickedDate) {
                  if (pickedDate != null) {
                    setState(() {
                      _timeStart.text =
                      "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                    });
                  }
                });
              },
            ),
          ),
          SizedBox(
            width: 200,
            child: TextField(
              style: const TextStyle(fontSize: 14),
              controller: _timeEnd,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_month),
                labelText: "Select end date",
              ),
              onTap: () async {
                await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2100))
                    .then((pickedDate) {
                  if (pickedDate != null) {
                    setState(() {
                      _timeEnd.text =
                      "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                    });
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
            _timeStart.text = _timeEnd.text = "";
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if(kIsWeb){
              final pdf = await PdfAnalytics.generate(
                  id, _timeStart.text, _timeEnd.text);
              Uint8List pdfInBytes = await pdf.save();
              final blob = html.Blob([pdfInBytes], 'application/pdf');
              final url = html.Url.createObjectUrlFromBlob(blob);
              anchor = html.document.createElement('a') as html.AnchorElement
                ..href = url
                ..style.display = 'none'
                ..download = 'Analytics.pdf';
              html.document.body!.children.add(anchor);
              anchor.click();
            }
            else{
              final pdf = await PdfAnalytics.generate(
                  id, _timeStart.text, _timeEnd.text);
              final pdfFile =await PdfAPI.saveDocument(name: "Analytics.pdf", pdf: pdf);
              PdfAPI.openFile(pdfFile);

            }

            _timeStart.text = _timeEnd.text = "";
            if (!mounted) return;
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget postponeDialog(BuildContext ctx,String id,String user,String date,String time) {
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
                ctx, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (await validateSlot(id)) {
              await FirebaseFirestore
                  .instance
                  .collection(
                  'counsellor')
                  .doc(
                  'counsellor@adcet.in')
                  .collection(
                  'session')
                  .doc(id)
                  .update({
                "date": DateFormat(
                    'yyyy/MM/dd')
                    .format(DateFormat(
                    'dd/MM/yyyy')
                    .parse(_date
                    .text)),
                "timeStart":
                _timeStart.text,
                "timeEnd":
                _timeEnd.text
              }).then((value) async {
                await FirebaseFirestore
                    .instance
                    .collection(
                    'users')
                    .doc(user)
                    .collection(
                    'session')
                    .doc(id)
                    .update({
                  "date": DateFormat(
                      'yyyy/MM/dd')
                      .format(DateFormat(
                      'dd/MM/yyyy')
                      .parse(_date
                      .text)),
                  "timeStart":
                  _timeStart.text,
                  "timeEnd":
                  _timeEnd.text
                }).then((value)async{
                  final notification = <String, String>{
                    "message":
                    "Your session on $date at $time is rescheduled on ${_date.text} at ${_timeStart.text}",
                  };
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .collection("notifications")
                      .doc(DateTime.now().toString())
                      .set(notification).then((value){
                    Fluttertoast.showToast(
                        msg:
                        "Modified successfully !");
                  });
                });
              });
              _date.text = _timeStart
                  .text =
                  _timeEnd.text = "";
              if (!mounted) {log("mounted");return;}
              Navigator.pop(
                  ctx, 'OK');
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
  }

  void cancelSession(String id, String user,String date,String time)async{

    await FirebaseFirestore.instance
        .collection('counsellor')
        .doc('counsellor@adcet.in')
        .collection('session')
        .doc(id)
        .delete()
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc('user')
          .collection('session')
          .doc(id)
          .delete()
          .then((value)async{
        final notification = <String, String>{
          "message":
          "Your session on $date at $time is cancelled.",
        };
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user)
            .collection("notifications")
            .doc(DateTime.now().toString())
            .set(notification).then((value){
          Fluttertoast.showToast(
              msg: "Session Cancelled");
        });

      });
    });
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
