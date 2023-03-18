import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pdf/widgets.dart';
import 'pdfAPI.dart';
import 'package:intl/intl.dart';

class PdfAnalytics {
  static Future<File> generate(
      String id, String startDate, String endDate) async {
    List<Widget> widgetList = [];
    final documentReference =
        FirebaseFirestore.instance.collection("counsellor").doc(id);

    widgetList.add(Text("Analytics for $startDate to $endDate",
        style: const TextStyle(fontSize: 20)));
    Set<String> userList = {};
    final genderMap = {};
    final classMap = {};
    final deptMap = {};
    QuerySnapshot snapshot = await documentReference
        .collection("completedSession")
        .where("date",
            isGreaterThanOrEqualTo: DateFormat('yyyy/MM/dd')
                .format(DateFormat('dd/MM/yyyy').parse(startDate)))
        .where("date",
            isLessThanOrEqualTo: DateFormat('yyyy/MM/dd')
                .format(DateFormat('dd/MM/yyyy').parse(endDate)))
        .get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    widgetList.add(Text("Total number of sessions : ${documents.length}"));
    for (var doc in documents) {
      log(doc["user"]);
      userList.add(doc["user"]);
    }
    log(userList.length.toString());

    widgetList.add(Text("Total number of users: ${userList.length}"));
    for (var user in userList) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user)
          .get()
          .then((DocumentSnapshot doc) {
        var data = doc.data() as Map<String, dynamic>;
        if (data["gender"] != null) {
          genderMap.update(
            data["gender"]!,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
        if (data["department"] != null) {
          deptMap.update(
            data["department"]!,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
        if (data["class"] != null) {
          classMap.update(
            data["class"]!,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      });
    }
    log(genderMap.toString());
    log(deptMap.toString());
    log(classMap.toString());
    widgetList.add(Text("Analytics by gender:$genderMap"));
    widgetList.add(Text("Analytics by Department:$deptMap"));
    widgetList.add(Text("Analytics by Class:$classMap"));

    final pdf = Document();
    pdf.addPage(MultiPage(build: (context) => widgetList));

    return PdfAPI.saveDocument(name: 'Analytics.pdf', pdf: pdf);
  }
}
