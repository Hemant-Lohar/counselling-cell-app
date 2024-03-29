import 'dart:developer';
// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../theme/Palette.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final String id = FirebaseAuth.instance.currentUser!.email!;
  String initial = "";
  String name = "";
  // String username="";
  final String dateTime =
      "${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";
  PrintingInfo? printingInfo;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((DocumentSnapshot doc)async{
      final info = await Printing.info();
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        name = data["name"];
        initial = data["name"][0].toString().toUpperCase();
        printingInfo=info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // floatingActionButton: CircleAvatar(
        //   radius: 25,
        //   backgroundColor: Palette.primary,
        //   child: IconButton(
        //     color: Colors.white,
        //     iconSize: 30,
        //     alignment: Alignment.bottomCenter,
        //     icon: const Icon(Icons.download),
        //     onPressed: () async{
        //       final pdfFile = await PdfUserHistory.generate(id,name);
        //       PdfAPI.openFile(pdfFile);
        //
        //     },
        //   ),
        // ),
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(id),
        //     IconButton(
        //       icon: const Icon(Icons.add_sharp),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) =>AddSessionWithUser(user: id,request: "")),
        //         );
        //       },
        //     ),
        //   ],
        // ))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              const Text("Previous Sessions"),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(id)
                    .collection("completedSession")
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshots.data!.size == 0) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              "No previous sessions",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ]);
                  } else {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                          return Column(
                            children: [
                              ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tileColor: Palette.tileback,
                                  leading: CircleAvatar(
                                    backgroundColor: Palette.primary,
                                    child: Text(
                                      initial,
                                      style:
                                      const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    "Date - ${DateFormat('dd/MM/yyyy').format(DateFormat('yyyy/MM/dd').parse(data["date"]))}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "Time - ${data["timeStart"]}-${data["timeEnd"]}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,

                                      // fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onTap: () {}

                                // leading: CircleAvatar(
                                //   backgroundImage: NetworkImage(data['image']),
                                // ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        });
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),


            ]),
          ),
        ));
  }
}
// style: ButtonStyle(
// backgroundColor:
// MaterialStateProperty.all<Color>(Palette.secondary),
// ),
