import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSessionWithUser extends StatefulWidget {
  const AddSessionWithUser({Key? key,required this.user}) : super(key: key);
  final String user;
  @override
  State<AddSessionWithUser> createState() => _AddSessionWithUserState(this.user);
}

class _AddSessionWithUserState extends State<AddSessionWithUser> {

  final TextEditingController _date = TextEditingController();
  final TextEditingController _timeStart = TextEditingController();
  final TextEditingController _timeEnd = TextEditingController();
  final TextEditingController _agenda = TextEditingController();
  DateTime dateTime = DateTime.now();
  final modeList =["Online","Offline"];
  String selectedMode="Online";
  String user;
  _AddSessionWithUserState(this.user);
  String username="";
  @override
  void initState(){

    FirebaseFirestore.instance.collection("users").doc(user).get().then((value){
      username=value.data()!["name"];
      log(username);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Session"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 350,
                child: TextField(

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
                          _date.text ="${pickedDate.day.toString().padLeft(2,"0")}/${pickedDate.month.toString().padLeft(2,"0")}/${pickedDate.year}";
                          dateTime = DateTime(pickedDate.year, pickedDate.month,
                              pickedDate.day, dateTime.hour, dateTime.minute);
                        });
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextField(
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
                              _timeStart.text = "${pickedTime.hour.toString().padLeft(2,"0")}:${pickedTime.minute.toString().padLeft(2,"0")}";
                              dateTime = DateTime(dateTime.year, dateTime.month,
                                  dateTime.day, pickedTime.hour, pickedTime.minute);
                            });
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30,),
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
                          initialTime: TimeOfDay.fromDateTime(dateTime.add(const Duration(minutes: 30))),
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

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("User: $user"),

                  DropdownButton(
                    value: selectedMode,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        selectedMode
                        = value!;
                      });
                    },
                    items: modeList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              Container(
                width: 350,
                child: TextField(
                  controller: _agenda,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.golf_course),
                    labelText: "Agenda of the session",
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: ()async{
                        final session = <String, String>{
                          "date": _date.text,
                          "timeStart": _timeStart.text,
                          "timeEnd": _timeEnd.text,
                          "user": user,
                          "username": username,
                          "agenda": _agenda.text,
                          "mode": selectedMode,
                        };
                        final dt = DateTime(dateTime.year,dateTime.month,dateTime.day,dateTime.hour).toString().substring(0,10).replaceAll("-", "");
                        final docId="$dt${_timeStart.text.replaceAll(":", "")}${_timeEnd.text.replaceAll(":", "")}";

                        if(await validate(docId,session)){
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
                          Fluttertoast.showToast(msg: "Session added successfully");

                          Navigator.pop(context);
                        }
                        else{
                          Fluttertoast.showToast(msg: "This time is not available");

                        }


                      },
                      child: const Text("Add")),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                ],
              )
            ],
          ),
        )
    );
  }

  Future<bool> validate(String docId,Map<String, String> session)async{
    final start=int.parse(docId.substring(08,12));
    final end=int.parse(docId.substring(12,16));
    // log(docId);
    final snapShot = await FirebaseFirestore.instance
        .collection('counsellor').doc("counsellor@gmail.com").collection("session").get();
    final List<DocumentSnapshot> documents = snapShot.docs;
    for (var doc in documents) {
      // log(doc.id.substring(8,12));
      // log(doc.id.substring(12,16));
      if(doc["date"]==session["date"]){
        if( start>int.parse(doc.id.substring(8,12)) && start<int.parse(doc.id.substring(12,16))){
          log("Conflict with starting time");
          return false;
        }
        if( end>int.parse(doc.id.substring(8,12)) && end<int.parse(doc.id.substring(12,16))){
          log("Conflict with ending time");
          return false;
        }
        if(start<int.parse(doc.id.substring(8,12)) && end>int.parse(doc.id.substring(12,16))){
          log("Schedule overlap");
          return false;
        }
      }

    }

    return true;
  }
}
