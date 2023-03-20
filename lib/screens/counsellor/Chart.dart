// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// import '../../theme/Palette.dart';
// import 'counsellorProfilePage.dart';

// final genderMap = {"Male": 0, "Female": 0, "LGBTQ+": 0};
// final classMap = {};
// final deptMap = {};

// class Chart extends StatefulWidget {
//   const Chart({super.key});

//   @override
//   State<Chart> createState() => _ChartState();
// }

// class _ChartState extends State<Chart> {
//   final String id = FirebaseAuth.instance.currentUser!.email!;
//   final username = FirebaseAuth.instance.currentUser!.email!;
//   String name = "";
//   String initial = "";

//   Set<String> userList = {};

//   void getData() async {
//     QuerySnapshot snapshot =
//         await FirebaseFirestore.instance.collection("users").get();
//     List<QueryDocumentSnapshot> documents = snapshot.docs;
//     for (var doc in documents) {
//       if (doc["gender"] != null) {
//         genderMap.update(
//           doc["gender"]!,
//           (value) => value + 1,
//           ifAbsent: () => 1,
//         );
//       }
//       if (doc["department"] != null) {
//         deptMap.update(
//           doc["department"]!,
//           (value) => value + 1,
//           ifAbsent: () => 1,
//         );
//       }
//       if (doc["class"] != null) {
//         classMap.update(
//           doc["class"]!,
//           (value) => value + 1,
//           ifAbsent: () => 1,
//         );
//       }
//     }
//     log(genderMap.toString());
//   }

//   @override
//   void initState() {
//     super.initState();
//     FirebaseFirestore.instance
//         .collection("counsellor")
//         .doc(username)
//         .get()
//         .then((DocumentSnapshot doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       setState(() {
//         name = data["name"];
//         initial = name[0].toString().toUpperCase();
//       });
//     });
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Hi, $name',
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         elevation: 0,
//         backgroundColor: Palette.primary[50],
//         actions: <Widget>[
//           InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const CounsellorProfile()));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: CircleAvatar(
//                   backgroundColor: Colors.black,
//                   child: Text(
//                     initial,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ))
//         ],
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               genderChart(),
//               deptChart(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget genderChart() {
//   final List<ChartData> chartData = [
//     ChartData("Male", genderMap["Male"]!.toDouble(), Colors.blue),
//     ChartData('Female', genderMap["Female"]!.toDouble(), Colors.orange),
//     ChartData('LGBTQ+', genderMap["LGBTQ+"]!.toDouble(), Colors.black),
//   ];
//   return (SfCircularChart(series: <CircularSeries>[
//     // Render pie chart
//     PieSeries<ChartData, String>(
//         dataSource: chartData,
//         pointColorMapper: (ChartData data, _) => data.color,
//         xValueMapper: (ChartData data, _) => data.x,
//         yValueMapper: (ChartData data, _) => data.y,
//         explode: true,
//         dataLabelSettings: const DataLabelSettings(
//             // Renders the data label
//             isVisible: true))
//   ]));
// }

// class ChartData {
//   ChartData(this.x, this.y, this.color);
//   final String x;
//   final double y;
//   final Color color;
// }




// Widget deptChart() {
//   final List<DeptData> chartData = [
//     DeptData("Com", deptMap["Computer Science & Engineering"]!.toDouble(), Colors.blue),
//     DeptData("Mech", deptMap["Mechanical Engineering"]!.toDouble(), Colors.orange),
//     // DeptData("Com", deptMap["Computer Science & Engineering"]!.toDouble(), Colors.blue),
    
//   ];
//   return (SfCartesianChart(series: <ColumnSeries>[
//     // Render pie chart
//     ColumnSeries<DeptData, String>(
//         dataSource: chartData,
//         pointColorMapper: (DeptData data, _) => data.color,
//         xValueMapper: (DeptData data, _) => data.x,
//         yValueMapper: (DeptData data, _) => data.y,
//         // explode: true,
//         dataLabelSettings: const DataLabelSettings(
//             // Renders the data label
//             isVisible: true))
//   ]));
// }

// class DeptData {
//   DeptData(this.x, this.y, this.color);
//   final String x;
//   final double y;
//   final Color color;
// }
