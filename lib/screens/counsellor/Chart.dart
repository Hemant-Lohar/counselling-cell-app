import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../theme/Palette.dart';
import 'counsellorProfilePage.dart';

final genderMap = {"Male": 0, "Female": 0, "LGBTQ+": 0};
final classMap = {};
final deptMap = {};

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final String id = FirebaseAuth.instance.currentUser!.email!;
  final username = FirebaseAuth.instance.currentUser!.email!;
  String name = "";
  String initial = "";

  Set<String> userList = {};

  void getData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    for (var doc in documents) {
      if (doc["gender"] != null) {
        genderMap.update(
          doc["gender"]!,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
      if (doc["department"] != null) {
        deptMap.update(
          doc["department"]!,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
      if (doc["class"] != null) {
        classMap.update(
          doc["class"]!,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }
    log(genderMap.toString());
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("counsellor")
        .doc(username)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        name = data["name"];
        initial = name[0].toString().toUpperCase();
      });
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Hi, $name',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        elevation: 0,
        backgroundColor: Palette.secondary,
        actions: <Widget>[
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CounsellorProfile()));
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  backgroundColor: Palette.primary,
                  child: Text(
                    initial,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Palette.secondary,
                  width: 400,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Analytics",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14,color: Colors.white),
                    ),
                  ),
                ),
                genderChart(),
                deptChart(),
                
                classChart()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget genderChart() {
  final List<ChartData> chartData = [
    ChartData("Male", genderMap["Male"]!, Colors.orange[400]!),
    ChartData('Female', genderMap["Female"]!, Colors.deepPurple[400]!),
    ChartData('LGBTQ+', genderMap["LGBTQ+"]!, Colors.black),
  ];
  return (SfCircularChart(
      legend: Legend(isVisible: true),
      backgroundColor: Palette.tileback,
      title: ChartTitle(
          text: 'Gender Wise Analysis',
          alignment: ChartAlignment.near,
          textStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      series: <CircularSeries>[
        // Render pie chart
        PieSeries<ChartData, String>(
            dataSource: chartData,
            pointColorMapper: (ChartData data, _) => data.color,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelMapper: (ChartData data, _) => data.y.toString(),
            dataLabelSettings: const DataLabelSettings(isVisible: true))
      ]));
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final int y;
  final Color color;
}

Widget deptChart() {
  return (SfCartesianChart(
          backgroundColor: Palette.tileback,

    title: ChartTitle(
        text: 'Department Wise Analysis',
        alignment: ChartAlignment.near,
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    primaryXAxis: CategoryAxis(
      majorGridLines: const MajorGridLines(width: 0),
      labelStyle: const TextStyle(color: Colors.black, fontSize: 10),
      labelPosition: ChartDataLabelPosition.outside,
    ),

    // isTransposed: true,
    series: <BarSeries>[
      BarSeries<ChartSampleData, String>(
        
          color: Colors.cyan,
          dataSource: <ChartSampleData>[
            ChartSampleData('Computer Science & Engineering',
                deptMap["Computer Science & Engineering"]),
            ChartSampleData(
                'Mechanical Engineering', deptMap["Mechanical Engineering"]),
            ChartSampleData('Civil Engineering', deptMap["Civil Engineering"]),
            ChartSampleData(
                'Electrical Engineering', deptMap["Electrical Engineering"]),
            ChartSampleData('Aeronautical Engineering',
                deptMap["Aeronautical Engineering"]),
            ChartSampleData('Food Technology', deptMap["Food Technology"]),
          ],
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ],
  ));
}

class ChartSampleData {
  ChartSampleData(this.x, this.y);
  final String x;
  final int y;
}

Widget classChart() {
  return (SfCartesianChart(
      backgroundColor: Palette.tileback,

    title: ChartTitle(
        text: 'Class Wise Analysis',
        alignment: ChartAlignment.near,
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    primaryXAxis: CategoryAxis(
      majorGridLines: const MajorGridLines(width: 0),
      labelStyle: const TextStyle(color: Colors.black, fontSize: 10),
      labelPosition: ChartDataLabelPosition.outside,
    ),

    // isTransposed: true,
    series: <BarSeries>[
      BarSeries<ClassChartData, String>(
          color: Colors.pink[400],
          dataSource: <ClassChartData>[
            ClassChartData('F.Y.B.Tech.', classMap["F.Y.B.Tech."]),
            ClassChartData('S.Y.B.Tech.', classMap["S.Y.B.Tech."]),
            ClassChartData('T.Y.B.Tech.', classMap["T.Y.B.Tech."]),
            ClassChartData('B.Tech.', classMap["B.Tech."]),
          ],
          xValueMapper: (ClassChartData data, _) => data.x,
          yValueMapper: (ClassChartData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ],
  ));
}

class ClassChartData {
  ClassChartData(this.x, this.y);
  final String x;
  final int y;
}
