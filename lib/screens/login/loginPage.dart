import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../counsellor/counsellorHomePage.dart';
import '../user/userHomePage.dart';
import 'registerPage.dart';

const List<Widget> role = <Widget>[Text('Counsellor'), Text('User')];
final List<bool> _selectedRole = <bool>[true, false];


class LoginDemo extends StatefulWidget {
  const LoginDemo({
    super.key,
  });

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var islogin = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static Future<User?> loginUsingEmailPassword(
      {required String email,
        required String password,
        required BuildContext context}) async {
    log("Done");
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Fluttertoast.showToast(
          msg: "User not found for this email", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1, // location// duration
        );
      }
    }
    return user;
  }

  _LoginDemoState();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text(
      //     "Login",
      //     style: TextStyle(
      //       color: Colors.black,
      //     ),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var children2 = [
                Container(
                  height: 280,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 80),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 185, 218, 243),
                          Color.fromARGB(255, 221, 240, 255)
                        ],
                      ),
                      image: DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomLeft)),
                ),
                const SizedBox(height: 50),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Column(
                      children: [
                        ToggleButtons(
                          isSelected: _selectedRole,
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0; i < _selectedRole.length; i++) {
                                _selectedRole[i] = i == index;
                              }
                            });
                          },
                          borderRadius:
                          const BorderRadius.all(Radius.circular(22)),
                          borderColor: Colors.black,
                          selectedBorderColor: Colors.black,
                          selectedColor: Colors.white,
                          fillColor: Colors.black,
                          color: Colors.black,
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 100.0,
                          ),
                          children: role,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              hintText: 'Enter Username',
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey))),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: 'Enter Password',
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey))),
                          style: const TextStyle(color: Colors.black),
                        ),

                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () async {

                            User? user = await loginUsingEmailPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                                context: context);
                            log(user.toString());
                            if (user != null && _selectedRole[1]) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const userHomePage()));
                            } else if (user != null && _selectedRole[0]) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                  const counsellorHomePage()));
                            } else {
                              Fluttertoast.showToast(
                                msg: "Invalid email or password", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1, // location// duration
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // const Text('Not Registered? Register here',
                        // style: TextStyle(color: Colors.black),)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Don't have an account? Register here",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ))
              ];
              return SingleChildScrollView(
                // padding: const EdgeInsets.all(36.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children2,
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
