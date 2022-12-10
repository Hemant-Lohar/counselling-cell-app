import 'package:flutter/material.dart';
import '../login/loginPage.dart';

class userHomePage extends StatefulWidget {
  const userHomePage({
    super.key,
  });
  @override
  _userHomePageState createState() => _userHomePageState();
}
class _userHomePageState extends State<userHomePage> {
  _userHomePageState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Homepage for user",
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
              const Text("Welcome!\nThis is Your Homepage!",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
              ElevatedButton(
                  onPressed: () {

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
                "User_Name",
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            ListTile(
              title: const Text('Sessions'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Recommendation'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Prescriptions'),
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
                  MaterialPageRoute(builder: (context) => const LoginDemo()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
