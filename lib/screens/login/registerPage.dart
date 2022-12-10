
import 'dart:developer';

import 'package:counselling_cell_application/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'loginPage.dart';

var _usernameController = TextEditingController();
var _passwordController = TextEditingController();
var _confirmPasswordController = TextEditingController();

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: const Text(
        //     "Register",
        //     style: TextStyle(
        //       color: Colors.black,
        //     ),
        //   ),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Image.asset('assets/register.png'),
                  const SizedBox(height: 60),
                  Center(
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Email Address',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey))),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () {
                        Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
                        if (validate()) {

                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: _usernameController.text.trim(),
                              password: _passwordController.text.trim())
                              .then((value) => {
                            Fluttertoast.showToast(
                              msg:
                              "Registered Successfully!", // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb:
                              1, // location// duration
                            ),
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const LoginDemo()),
                            )
                          })
                              .onError((error, stackTrace) => {
                            Fluttertoast.showToast(
                              msg: "Registration Failed!", // message
                              toastLength: Toast.LENGTH_SHORT, // length
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb:
                              1, // location// duration
                            )
                          });
                        }

                        // if (validate()) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => LoginDemo()),
                        //   );
                        // Fluttertoast.showToast(
                        //   msg: "Registered Successfully!!", // message
                        //   toastLength: Toast.LENGTH_SHORT, // length
                        //   gravity: ToastGravity.CENTER,
                        //   timeInSecForIosWeb: 1, // location// duration
                        // );
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Register')),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginDemo()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Already Registered? Login here",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  bool validate() {
    String patternUsername =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regexUsername = RegExp(patternUsername);
    String patternPassword =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regexPassword = RegExp(patternPassword);
    if (!regexUsername.hasMatch(_usernameController.text)) {
      Fluttertoast.showToast(
        msg: "Invalid email id", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1, // location// duration
      );
      return false;
    }
    if (!regexPassword.hasMatch(_passwordController.text)) {
      Fluttertoast.showToast(
        msg: "Invalid password", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1, // location// duration
      );
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: "Passwords do not match", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1, // location// duration
      );
      return false;
    }

    return true;
    // Continue
  }
}
