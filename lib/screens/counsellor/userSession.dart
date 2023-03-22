import 'dart:developer';
// import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'pdfUserHistory.dart';
import 'pdfAPI.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import '../../theme/Palette.dart';
import 'addSessionWithUser.dart';

class UserSession extends StatefulWidget {
  const UserSession({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<UserSession> createState() => _UserSessionState();
}

class _UserSessionState extends State<UserSession> {
  late final String id;
  String initial = "";
  String name = "";
  var anchor;
  final String dateTime =
      "${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";
  PrintingInfo? printingInfo;
  @override
  void initState() {
    super.initState();
    id = widget.id;
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
        appBar: AppBar(
            leading: const BackButton(color: Colors.white),
            backgroundColor: Palette.secondary,
            title: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                CircleAvatar(
                  backgroundColor: Palette.ternary[800],
                  child: IconButton(
                    // style:  const ButtonStyle(backgroundColor: Colors.orange),
                    icon: const Icon(
                      Icons.add_sharp,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddSessionWithUser(user: id, request: "")),
                      );
                    },
                  ),
                ),
              ],
            ))),
        floatingActionButton: CircleAvatar(
          radius: 25,
          backgroundColor: Palette.primary,
          child: IconButton(
            color: Colors.white,
            iconSize: 30,
            alignment: Alignment.bottomCenter,
            icon: const Icon(Icons.download),
            onPressed: () async{

              if(kIsWeb){
                final pdf = await PdfUserHistory.generate(id,name);
                Uint8List pdfInBytes = await pdf.save();
                final blob = html.Blob([pdfInBytes], 'application/pdf');
                final url = html.Url.createObjectUrlFromBlob(blob);
                anchor = html.document.createElement('a') as html.AnchorElement
                  ..href = url
                  ..style.display = 'none'
                  ..download = '$name history.pdf';
                html.document.body!.children.add(anchor);
                anchor.click();
              }
              else{
                final pdf = await PdfUserHistory.generate(id,name);
                final pdfFile =await PdfAPI.saveDocument(name: '${name}_history.pdf', pdf: pdf);
                PdfAPI.openFile(pdfFile);

              }

            },
          ),
        ),
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
                height: 10,
              ),
              const Text("Upcoming"),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(id)
                    .collection("session")
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
                              "No upcoming sessions",
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
                        itemCount: snapshots.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = snapshots.data!.docs[index].data()
                              as Map<String, dynamic>;
                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                tileColor: Palette.tileback,
                                leading: CircleAvatar(
                                  backgroundColor: Palette.primary,
                                  child: Text(
                                    id[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  "Date - ${DateFormat('dd/MM/yyyy').format(DateFormat('yyyy/MM/dd').parse(data["date"]))}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black87,
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

                                onTap: () {},
                                // leading: CircleAvatar(
                                //   backgroundImage: NetworkImage(data['image']),
                                // ),
                              ),
                            ],
                          );
                        });
                  }
                },
              ),
              const SizedBox(
                height: 10,
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
