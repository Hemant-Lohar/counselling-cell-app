import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:date_time_picker/date_time_picker.dart';

class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text("Sessions"),
      )),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                showAlertDialog(context);
                // final city = <String, String>{
                //   "name": "Los Angeles",
                //   "state": "CA",
                //   "country": "USA"
                // };
                // await FirebaseFirestore.instance
                //     .collection("users")
                //     .doc("sangram@gmail.com")
                //     .collection("session")
                //     .doc("1234")
                //     .set(city);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) async {
    DateTime dateTime=DateTime.now();
    TextEditingController _date = TextEditingController();
    TextEditingController _time = TextEditingController();
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Schedule a session"),
          content: Column(
            children: [
              TextField(
                controller: _date,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month),
                  labelText: "Select a date",
                ),
                onTap: () async {
                  await showDatePicker(
                          context: context,
                          initialDate:dateTime,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100))
                      .then((pickedDate) {
                    if (pickedDate != null) {
                      setState(() {
                        _date.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        dateTime=DateTime(pickedDate.year,pickedDate.month,pickedDate.day,dateTime.hour,dateTime.minute);
                      });
                    }
                    return null;
                  });
                },
              ),
              TextField(
                controller: _time,
                decoration: const InputDecoration(
                  icon: Icon(Icons.access_time),
                  labelText: "Select Time",
                ),
                onTap: () async {
                  await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(dateTime),

                  ).then((pickedTime) {
                    if (pickedTime != null) {
                      setState(() {
                        _time.text =
                            "${pickedTime.hour}:${pickedTime.minute} ";
                        dateTime=DateTime(dateTime.year,dateTime.month,dateTime.day,pickedTime.hour,pickedTime.minute);
                      });
                    }
                    return null;
                  });
                },
              ),

            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
