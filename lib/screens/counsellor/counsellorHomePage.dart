
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class CounsellorHomePage extends StatefulWidget {
  const CounsellorHomePage({Key? key}) : super(key: key);

  @override
  State<CounsellorHomePage> createState() => _CounsellorHomePageState();
}

class _CounsellorHomePageState extends State<CounsellorHomePage> {
  @override
  Widget build(BuildContext context) {
    final username = FirebaseAuth.instance.currentUser!.email!;
    String name = username.substring(0, username.indexOf('@'));
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(children: [
                Text("Welcome $name !\nThis is Your Homepage.",
                    style: const TextStyle(color: Colors.black, fontSize: 30)),
                const SizedBox(
                  height: 30,
                ),
                // ElevatedButton(onPressed: () async{
                //
                // }, child: const Text("Send"))
              ]),
            )));
  }
}

// import 'package:counselling_cell_application/screens/counsellor/addUser.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';

// import '../login/loginPage.dart';
// import 'userList.dart';

// class counsellorHomePage extends StatefulWidget {
//   final User user;
//   const counsellorHomePage({
//     super.key,
//     required this.user,
//   });
//   @override
//   _counsellorHomePageState createState() => _counsellorHomePageState(this.user);
// }

// class _counsellorHomePageState extends State<counsellorHomePage> {
//   User user;
//   late String username= user.email.toString();
//   _counsellorHomePageState(this.user);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Homepage for counsellor",
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.grey,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(36.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//                Text("Welcome $username !\nThis is Your Homepage.",
//                   style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30)),
//               const SizedBox(
//                 height: 30,
//               ),
//               ElevatedButton(onPressed: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AddUser()),
//                 );

//               }, child: const Text("Add new user",style:TextStyle(
//                 fontSize: 20,
//               ),)),
//             ],
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         // Add a ListView to the drawer. This ensures the user can scroll
//         // through the options in the drawer if there isn't enough vertical
//         // space to fit everything.
//         child: ListView(
//           // Important: Remove any padding from the ListView.
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: Text(
//                 username,
//                 textAlign: TextAlign.justify,
//                 style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 20
//                 ),
//               ),
//             ),
//             ListTile(
//               title: const Text('Reports'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Events'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Users'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer

//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const UserList()),
//                 );
//               },
//             ),
//             ListTile(
//               title: const Text('Logout'),
//               onTap: () {
//                 Navigator.popUntil(
//                   context,
//                   ModalRoute.withName('/'),
//                 );
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const LoginPage()),
//                 );

//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
