import 'package:counselling_cell_application/screens/counsellor/session.dart';
import 'package:counselling_cell_application/screens/counsellor/userList.dart';
import 'package:flutter/material.dart';

import 'counsellorHomePage.dart';

class ViewUser extends StatefulWidget {
  ViewUser({super.key,required this.id});
  final String id;
  @override
  State<ViewUser> createState() => _ViewUserState(this.id);
}

class _ViewUserState extends State<ViewUser> {
  String id;

  _ViewUserState(this.id);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ListView(
            children: [
              const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                  radius: 60,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Name: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16)),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Age: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16)),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Gender: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16)),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Mobile: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16)),
                    SizedBox(
                      height: 10,
                    ),
                   
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
