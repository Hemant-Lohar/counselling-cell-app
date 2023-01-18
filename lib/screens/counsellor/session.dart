import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/counsellor/addSessionWithUser.dart';
import 'package:flutter/material.dart';

import 'addSession.dart';
// import 'package:date_time_picker/date_time_picker.dart';

class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {

  final String dateTime =
      "${DateTime.now().day.toString().padLeft(2,"0")}/${DateTime.now().month.toString().padLeft(2,"0")}/${DateTime.now().year}";
  @override
  void initState() {


    log("Date:$dateTime");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Upcoming Sessions"),
            IconButton(
              icon: const Icon(Icons.add_sharp),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddSession()),
                );
              },
            ),
          ],
        ))),
        body: SingleChildScrollView(
          child: Column(
              children: [
            const Text("Today"),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('counsellor')
                  .doc("counsellor@gmail.com")
                  .collection("session")
                  .where("date", isEqualTo: dateTime)
                  .snapshots(),
              builder: (context, snapshots) {
                return (snapshots.connectionState == ConnectionState.waiting)
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                      return ListTile(
                        title: Text(
                          "${data["timeStart"]}-${data["timeEnd"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,

                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Text(
                          data['username'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {

                        }

                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage(data['image']),
                        // ),
                      );
                    });
              },
            ),
            const Text("Later On"),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('counsellor')
                  .doc("counsellor@gmail.com")
                  .collection("session")
                  .where("date", isGreaterThan: dateTime)
                  .snapshots(),
              builder: (context, snapshots) {
                return (snapshots.connectionState == ConnectionState.waiting)
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshots.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                      as Map<String, dynamic>;
                      return ListTile(
                        title: Text(
                          "${data['date']}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Text(
                          "${data['username']} at ${data["timeStart"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),

                        onTap: () {},
                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage(data['image']),
                        // ),
                      );
                    });
              },
            ),
          ]),
        ));
  }
}
