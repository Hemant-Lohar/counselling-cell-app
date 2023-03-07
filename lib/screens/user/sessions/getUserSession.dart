// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class GetUserSession extends StatefulWidget {
//   const GetUserSession({super.key});

//   @override
//   State<GetUserSession> createState() => _GetUserSessionState();
// }

// class _GetUserSessionState extends State<GetUserSession> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(username)
//             .collection("session")
//             .where("date", isGreaterThanOrEqualTo: dateTime)
//             .snapshots(),
//         builder: (context, snapshots) {
//           if (snapshots.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshots.data!.size == 0) {
//             return Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       "You have no appointments scheduled !!",
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   showRequestButton
//                       ? ElevatedButton(
//                           onPressed: () {
//                             Future.delayed(
//                                 const Duration(seconds: 0),
//                                 () => showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return getAlertDialog();
//                                     }));
//                           },
//                           child: const Text("Request an appointment"))
//                       : Container(),
//                 ]);
//           } else {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Your upcoming session",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 30,
//                     // fontWeight: FontWeight.bold
//                   ),
//                 ),
//                 ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: snapshots.data!.docs.length,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       var data = snapshots.data!.docs[index].data()
//                           as Map<String, dynamic>;
//                       return ListTile(
//                         contentPadding: const EdgeInsets.all(8.0),
//                         horizontalTitleGap: 0.0,
//                         title: Text(
//                           data['date'],
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 20,
//                             // fontWeight: FontWeight.bold
//                           ),
//                         ),
//                         trailing: Text(
//                           "${data["timeStart"]}-${data["timeEnd"]}",
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 20,
//                           ),
//                         ),
//                         subtitle: Text(
//                           data['mode'],
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 15,
//                             // fontWeight: FontWeight.bold
//                           ),
//                         ),

//                         onTap: () {},
//                         // leading: CircleAvatar(
//                         //   backgroundImage: NetworkImage(data['image']),
//                         // ),
//                       );
//                     }),
//               ],
//             );
//           }
//         });
//   }
// }
