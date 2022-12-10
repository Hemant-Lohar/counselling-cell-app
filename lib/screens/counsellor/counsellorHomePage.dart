import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../login/loginPage.dart';



class counsellorHomePage extends StatefulWidget {
  const counsellorHomePage({
    super.key,
  });
  @override
  _counsellorHomePage createState() => _counsellorHomePage();
}

class _counsellorHomePage extends State<counsellorHomePage> {
  _counsellorHomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Homepage for counsellor",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Welcome counsellor!\nThis is Your Homepage!",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
              ElevatedButton(onPressed: (){

              }, child: const Text("Video calling demo")),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                "Counsellor_Name",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
            ),
            ListTile(
              title: const Text('Reports'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Events'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Users'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/'),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginDemo()),
                );

              },
            ),
          ],
        ),
      ),
    );
  }
}
