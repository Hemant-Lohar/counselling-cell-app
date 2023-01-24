import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addSession.dart';
// import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        appBar: AppBar(
            title: Center(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Upcoming Sessions"),
            IconButton(
              icon: const Icon(Icons.add_sharp),
              onPressed: () {
                Navigator.push(
                  context,
                  // ignore: prefer_const_constructors
                  MaterialPageRoute(builder: (context) => AddSession()),
                );
              },
            ),
          ],
        ))),
        body: SingleChildScrollView(
          child: Column(children: [
            const Text("Today"),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('counsellor')
                  .doc("counsellor@gmail.com")
                  .collection("session")
                  .where("date", isEqualTo: dateTime)
                  .orderBy("timeStart")
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
                              title: Text(
                                "${data["timeStart"]}-${data["timeEnd"]}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,

                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text(
                                data['username'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: PopupMenuButton<String>(
                                initialValue: selectedAction,
                                // Callback that sets the selected popup menu item.
                                onSelected: (String item) {
                                  setState(() {
                                    selectedAction = item;
                                  });
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: "Start",
                                    child: const Text("Start"),
                                    onTap: (){

                                    },
                                  ),
                                  PopupMenuItem<String>(
                                    value:"Postpone" ,
                                    child: const Text("Postpone"),
                                    onTap: (){
                                      Future.delayed(
                                          const Duration(seconds: 0),
                                      () =>  showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return  AlertDialog(
                                              title: const Text('Postpone Session'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:130,
                                                    child: TextField(

                                                      controller: _date,
                                                      decoration: const InputDecoration(
                                                        icon: Icon(Icons.calendar_month),
                                                        labelText: "Select a date",

                                                      ),
                                                      onTap: () async {
                                                        await showDatePicker(

                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime.now(),
                                                            lastDate: DateTime(2100))
                                                            .then((pickedDate) {
                                                          if (pickedDate != null) {
                                                            setState(() {
                                                              _date.text ="${pickedDate.day.toString().padLeft(2,"0")}/${pickedDate.month.toString().padLeft(2,"0")}/${pickedDate.year}";
                                                            });
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: TextField(
                                                      controller: _timeStart,
                                                      decoration: const InputDecoration(
                                                        icon: Icon(Icons.access_time),
                                                        labelText: "Start Time",
                                                      ),
                                                      onTap: () async {
                                                        await showTimePicker(
                                                          context: context,
                                                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                                                        ).then((pickedTime) {
                                                          if (pickedTime != null) {
                                                            setState(() {
                                                              _timeStart.text = "${pickedTime.hour.toString().padLeft(2,"0")}:${pickedTime.minute.toString().padLeft(2,"0")}";
                                                              tmd=pickedTime;
                                                            });
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: TextField(
                                                      controller: _timeEnd,
                                                      decoration: const InputDecoration(
                                                        icon: Icon(Icons.access_time_filled_sharp),
                                                        labelText: "End Time",
                                                      ),
                                                      onTap: () async {
                                                        await showTimePicker(

                                                          context: context,
                                                          initialTime: tmd!,
                                                        ).then((pickedTime) {
                                                          if (pickedTime != null) {
                                                            setState(() {
                                                              _timeEnd.text = "${pickedTime.hour.toString().padLeft(2,"0")}:${pickedTime.minute.toString().padLeft(2,"0")}";

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
                                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: ()async{
                                                    await FirebaseFirestore.
                                                    instance.
                                                    collection('counsellor').
                                                    doc('counsellor@gmail.com').
                                                    collection('session').
                                                    doc(snapshots.data!.docs[index].id).
                                                    update(
                                                        {
                                                          "date":_date.text,
                                                          "timeStart":_timeStart.text,
                                                          "timeEnd":_timeEnd.text
                                                        }
                                                        ).then((value)async{
                                                      await FirebaseFirestore.
                                                      instance.collection('users').
                                                      doc(data['user']).
                                                      collection('session').
                                                      doc(snapshots.data!.docs[index].id.toString()).
                                                      update(
                                                          {
                                                            "date":_date.text,
                                                            "timeStart":_timeStart.text,
                                                            "timeEnd":_timeEnd.text
                                                          }
                                                      );
                                                    });
                                                    _date.text=_timeStart.text=_timeEnd.text="";
                                                    Navigator.pop(context, 'OK');
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        ),);


                                    }
                                  ),
                                  PopupMenuItem<String>(
                                    value: "Cancel",
                                    child: const  Text("Cancel"),
                                    onTap: ()async{
                                      await FirebaseFirestore.instance.collection('counsellor').doc('counsellor@gmail.com').collection('session').doc(snapshots.data!.docs[index].id.toString()).delete().then((value)async{
                                        await FirebaseFirestore.instance.collection('users').doc(data['user']).collection('session').doc(snapshots.data!.docs[index].id.toString()).delete().then((value){
                                          Fluttertoast.showToast(msg: "Session Cancelled");
                                        });
                                      });

                                    },
                                  ),
                                ],
                              ),

                              // leading: CircleAvatar(
                              //   backgroundImage: NetworkImage(data['image']),
                              // ),
                              );
                        });
              },
            ),
            const Text("Later On"),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('counsellor')
                  .doc("counsellor@gmail.com")
                  .collection("session")
                  .where("date", isGreaterThan: dateTime)
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
                          return ListTile(
                            title: Text(
                              "${data['date']}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text(
                              "${data['username']} at ${data["timeStart"]}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),

                            trailing: PopupMenuButton<String>(
                              initialValue: selectedAction,
                              // Callback that sets the selected popup menu item.
                              onSelected: (String item) {
                                setState(() {
                                  selectedAction = item;
                                });
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[

                                PopupMenuItem<String>(
                                  value:"Postpone" ,
                                  child: const Text("Postpone"),
                                  onTap: (){
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('AlertDialog Title'),
                                        content: const Text('AlertDialog description'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                PopupMenuItem<String>(
                                  value: "Cancel",
                                  child: const Text("Cancel"),
                                  onTap: ()async{
                                    await FirebaseFirestore.instance.collection('counsellor').doc('counsellor@gmail.com').collection('session').doc(snapshots.data!.docs[index].id.toString()).delete().then((value)async{
                                      await FirebaseFirestore.instance.collection('users').doc(data['user']).collection('session').doc(snapshots.data!.docs[index].id.toString()).delete().then((value){
                                        Fluttertoast.showToast(msg: "Session Cancelled");
                                      });
                                    });

                                  },
                                ),
                              ],
                            ),
                            // leading: CircleAvatar(
                            //   backgroundImage: NetworkImage(data['image']),
                            // ),
                          );
                        });
              },
            ),
          ]),
        ));
  }
}
