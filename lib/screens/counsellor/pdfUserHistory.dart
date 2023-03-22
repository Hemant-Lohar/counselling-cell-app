import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
// import 'package:pdf/widgets.dart';
import 'pdfAPI.dart';
import 'package:pdf/widgets.dart';

String _user = "";

class PdfUserHistory {
  static Future<Document> generate(String user, String name) async {
    _user = user;
    List<Widget> widgetList = [];
    final pdf = Document();
    final headerimg = MemoryImage(
      (await rootBundle.load('assets/pdfheader.png')).buffer.asUint8List(),
    );

    final documentReference =
        FirebaseFirestore.instance.collection("users").doc(user);
    await documentReference.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      log(data["name"]);

      widgetList.add(
        Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Image(headerimg),
                  Divider(),
                  Center(
                      child: Text("Basic Info",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Text("Name: ${data["name"]}"), //
                  Text("Age: ${data["age"]}"), // <-
                  Text("Gender: ${data["gender"]}"), //
                  Text("Mobile No.: ${data["mobile"]}"), //
                  Text("Department: ${data["department"]}"),
                  Text("Class: ${data["class"]}"), //
                  Text("Division ${data["division"]}"),
                  Text("URN: ${data["urn"]}"),
                  Text("Email ID: ${data["id"]}"),
                  Divider()
                ])),
      );
    });
    await documentReference.collection("completedSession").get().then(
      (querySnapshot) {
        if (querySnapshot.size == 0) {
          widgetList.add(Text("No sessions are conducted for user:$name"));
        } else {
          for (var docSnapshot in querySnapshot.docs) {
            var data = docSnapshot.data();
            widgetList.add(Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Center(
                          child: Text("Session Info",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Text("Session No.: ${data["sessionNumber"]}"),
                      Text("Date: ${data["date"]}"),
                      Text("Time: ${data["timeStart"]} to ${data["timeEnd"]}"),
                      Text("Type of visit : ${data["mode"]}"),
                      Text("Observation: ${data["observation"]}"),
                      Text("New issues found: ${data["new_issues"]}"),
                      Text("Details of session: ${data["details"]}"),
                      Divider()
                    ])));
          }
        }
      },
      onError: (e) => log("Error completing: $e"),
    );

    // final pdf = Document();
    pdf.addPage(MultiPage(build: (context) => widgetList));

    return pdf;
  }
}
