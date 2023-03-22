import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/counsellor/addUser.dart';
import 'package:counselling_cell_application/theme/palette.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewUser extends StatefulWidget {
  const ViewUser({super.key, required this.id});
  final String id;
  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  late String id;
  final dataStyle = const TextStyle(fontSize: 14, color: Colors.black);
  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Palette.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        //
        // physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          // textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error = ${snapshot.error}');
                } else if (snapshot.hasData) {
                  var output = snapshot.data!.data();

                  var name =      output!['name']; // <-- Your value
                  var age =       output['age']; // <-- Your value
                  var gender =    output['gender']; // <-- Your value
                  var mobile =    output['mobile']; // <-- Your value
                  var dept =      output['department']; // <-- Your value
                  var clas =      output['class']; // <-- Your value
                  var division =  output['division'];
                  var urn =       output["urn"];
                  var emotion = output["emotion"];
                  var score = output["score"];
                  var initial = name[0].toUpperCase();
                  // print(output.containsValue('referral'));

                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        const SizedBox(height: 30),
                        CircleAvatar(
                          backgroundColor: Palette.primary,
                          radius: 50,
                          child: Text(
                            initial,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 48),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: $name',
                                style: dataStyle),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Age: $age',
                                style: dataStyle),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Gender: $gender',
                                style: dataStyle),
                            const SizedBox(
                              height: 10,
                            ),

                            Text('Dominant emotion: $emotion',
                                style: dataStyle),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Assessment score: $score',
                                style: dataStyle),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Department: $dept',
                                style: dataStyle),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Class : $clas',
                                style: dataStyle),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Division : $division',
                                style: dataStyle),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('URN : $urn',
                                style: dataStyle),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Mobile : $mobile',
                                style: dataStyle),

                            //
                            // Text('Reffered By : $referedby',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Familydetails : $familydetails',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Reason for Reffered : $reasonreferral',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Family History : $familyhistory',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Observation: $observation',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Text('Reccomendation : $reccomendation',
                            //     style: const TextStyle(
                            //         color: Colors.black, fontSize: 14)),
                          ],
                        ),
                      ]));
                } else {
                  return const Center(child: CircularProgressIndicator());
                } // <-- Your value
              },
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error = ${snapshot.error}');
                } else if (snapshot.hasData) {
                  var output = snapshot.data!.data();

                  var referral = output!["referral"];
                  var reasonReferral = output["reasonReferral"];
                  var parentMobile = output["parentMobile"];
                  var informant = output["informant"];
                  var info = output["info"];
                  var complaint = output["complaint"];
                  var familyHistory = output["familyHistory"];
                  var parentDetails = output["parentDetails"];
                  var siblings = output["siblings"];
                  var birthOrder = output["birthOrder"];
                  var pastmedicalHistory = output["pastmedicalHistory"];
                  var medicalHistory = output["medicalHistory"];
                  var birthEarlyDevelopment = output["birthEarlyDevelopment"];
                  var childBehaviour = output["childBehaviour"];
                  var childIllness = output["childIllness"];
                  var menstrual = output["menstrual"];
                  var sexual = output["sexual"];
                  var marital = output["marital"];
                  var alcohol = output["alcohol"];
                  var substance = output["substance"];
                  var ssc = output["ssc"];
                  var hscDiploma = output["hscDiploma"];
                  var entranceExam = output["entranceExam"];
                  var cgpa = output["cgpa"];
                  var extraInfo = output["extraInfo"];
                  var assessment = output["assessment"];
                  var observation = output["observation"];
                  var reccomendation = output["reccomendation"];

                  // print(output.containsValue('referral'));

                  if (output.containsKey('referral')) {
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Referred by: $referral",
                                  style: dataStyle),
                              Text("Reason for Referral: $reasonReferral",
                                  style: dataStyle),
                              Text("Parents Mobile Number:$parentMobile",
                                  style: dataStyle),
                              Text("Informant: $informant",
                                  style: dataStyle),
                              Text(
                                  "Information given by Parents / teacher: $info",
                                  style: dataStyle),
                              Text("Chief Complaints and History: $complaint",
                                  style: dataStyle),
                              Text("Family History: $familyHistory",
                                  style:dataStyle),
                              Text("Parents information: $parentDetails",
                                  style: dataStyle),
                              Text("Siblings: $siblings",
                                  style: dataStyle),
                              Text("Birth Order: $birthOrder",
                                  style: dataStyle),
                              Text(
                                  "Past medical/ psychiatric history: $pastmedicalHistory",
                                  style: dataStyle),
                              Text(
                                  "Medical and Psychiatric History: $medicalHistory",
                                  style: dataStyle),
                              Text(
                                  "(Birth and Early Development: $birthEarlyDevelopment",
                                  style: dataStyle),
                              Text(
                                  "Behaviour during Childhood: $childBehaviour",
                                  style: dataStyle),
                              Text(
                                  " Physical Illness during Childhood: $childIllness",
                                  style: dataStyle),
                              Text(" Menstrual History: $menstrual",
                                  style: dataStyle),
                              Text("Sexual History: $sexual",
                                  style: dataStyle),
                              Text(" Marital History : $marital",
                                  style: dataStyle),
                              Text("Use and abuse of alcohol : $alcohol",
                                  style: dataStyle),
                              Text("tobacco and drug abuse: $substance",
                                  style: dataStyle),
                              Text("10th marks: $ssc",
                                  style: dataStyle),
                              Text("12th/Diploma marks: $hscDiploma",
                                  style: dataStyle),
                              Text("JEE/CET marks: $entranceExam",
                                  style: dataStyle),
                              Text("Current academic performance: $cgpa",
                                  style: dataStyle),
                              Text("Extra Info(if any): $extraInfo",
                                  style: dataStyle),
                              Text("Assessment (if any): $assessment",
                                  style: dataStyle),
                              Text("Observation: $observation",
                                  style: dataStyle),
                              Text("Reccomendation: $reccomendation",
                                  style: dataStyle),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        if (id.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddUser(id: id)));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Palette.secondary),
                      ),
                      child: const Text("Enter Details"),
                    );
                  } // <-- Your value
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
