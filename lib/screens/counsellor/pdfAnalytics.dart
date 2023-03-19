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
    final genderMap = {"Male":0,"Female":0,"LGBTQ+":0};
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

// List<Weight> weightData =
//   genderMap.entries.map( (entry) => Weight(entry.key, entry.value)).toList();

    widgetList.add(Column(children: [
      Center(
          child: Text("Gender", style: TextStyle(fontWeight: FontWeight.bold))),
      Table(border: TableBorder.all(), columnWidths: {
        0: const FixedColumnWidth(40),
        1: const FixedColumnWidth(40)
      }, children: <TableRow>[
        TableRow(
          children: <Widget>[
            Text("Male", textAlign: TextAlign.center),
            Text(genderMap["Male"].toString(), textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("Female", textAlign: TextAlign.center),
            Text(genderMap["Female"].toString(), textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("LGBTQ+", textAlign: TextAlign.center),
            Text(genderMap["LGBTQ+"].toString(), textAlign: TextAlign.center),
          ],
        ),
      ])
    ]));

    widgetList.add(Column(children: [
      Center(
          child: Text("Department",
              style: TextStyle(fontWeight: FontWeight.bold))),
      Table(border: TableBorder.all(), columnWidths: {
        0: const FixedColumnWidth(40),
        1: const FixedColumnWidth(40)
      }, children: <TableRow>[
        TableRow(
          children: <Widget>[
            Text("Computer Science & Engineering", textAlign: TextAlign.center),
            Text(deptMap["Computer Science & Engineering"].toString(),
                textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("Mechanical Engineering", textAlign: TextAlign.center),
            Text(deptMap["Mechanical Engineering"].toString(),
                textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("Civil Engineering", textAlign: TextAlign.center),
            Text(deptMap["Civil Engineering"].toString(),
                textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("Electrical Engineering", textAlign: TextAlign.center),
            Text(deptMap["Electrical Engineering"].toString(),
                textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("Aeronautical Engineering", textAlign: TextAlign.center),
            Text(deptMap["Aeronautical Engineering"].toString(),
                textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("Food Technology", textAlign: TextAlign.center),
            Text(deptMap["Food Technology"].toString(),
                textAlign: TextAlign.center),
          ],
        ),
      ])
    ]));

    widgetList.add(Column(children: [
      Center(
          child: Text("Class", style: TextStyle(fontWeight: FontWeight.bold))),
      Table(border: TableBorder.all(), columnWidths: {
        0: const FixedColumnWidth(40),
        1: const FixedColumnWidth(40)
      }, children: <TableRow>[
        TableRow(
          children: <Widget>[
            Text("F.Y.B.Tech.", textAlign: TextAlign.center),
            Text(classMap["F.Y.B.Tech."].toString(), textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("S.Y.B.Tech.", textAlign: TextAlign.center),
            Text(classMap["S.Y.B.Tech."].toString(), textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("T.Y.B.Tech.", textAlign: TextAlign.center),
            Text(classMap["T.Y.B.Tech."].toString(), textAlign: TextAlign.center),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text("B.Tech.", textAlign: TextAlign.center),
            Text(classMap["B.Tech."].toString(), textAlign: TextAlign.center),
          ],
        ),
        
      ])
    ]));

    final pdf = Document();
    pdf.addPage(MultiPage(build: (context) => widgetList));

    return PdfAPI.saveDocument(name: "Analytics.pdf", pdf: pdf);
  }
}

// class Weight {
//   final double male;
//   final double female;

//   Weight(this.male, this.female);
// }
