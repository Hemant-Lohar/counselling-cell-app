import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

TextEditingController _fnameController = TextEditingController();
TextEditingController _lnameController = TextEditingController();
TextEditingController _ageController = TextEditingController();
TextEditingController _genderController = TextEditingController();
TextEditingController _urnController = TextEditingController();

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: ListView(
          children: [
            const TextField(
              decoration: InputDecoration(hintText: "Refered By"),
              maxLines: null,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(hintText: "Family Details"),
              maxLines: null,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(hintText: "Reason for Refered"),
              maxLines: null,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(hintText: "Present Complaints"),
              maxLines: null,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                  hintText: "History for Metal or physical illness"),
              maxLines: null,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                  hintText: "Family history for Mental illness"),
              maxLines: null,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                  hintText: "Family history for Mental illness"),
              maxLines: null,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(
                  hintText: "Observation during history session"),
              maxLines: null,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(hintText: "Recomendations"),
              maxLines: null,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  // if (validate()) {
                  //   addtofirebase(fname, lname, age, gender, urn);
                  //   _fnameController.text = "";
                  //   _lnameController.text = "";
                  //   _ageController.text = "";
                  //   _genderController.text = "";
                  //   _urnController.text = "";
                  //   Navigator.pop(context);
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: const StadiumBorder(),
                ),
                child: const Text("Add Details"))
          ],
        ),
      ),
    );
  }

  addtofirebase(
      String fname, String lname, int age, String gender, int urn) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(urn.toString())
        .set({
      "fname": fname,
      "lname": lname,
      "age": age,
      "gender": gender,
      "urn": urn
    });
  }

  bool validate() {
    if (_fnameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "First name cannot be empty");
      return false;
    }
    if (_lnameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Last name cannot be empty");
      return false;
    }
    if (_ageController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Invalid age");
      return false;
    }
    if (_genderController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Invalid Gender");
      return false;
    }
    if (_urnController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Invalid URN");
      return false;
    }
    return true;
  }
}
