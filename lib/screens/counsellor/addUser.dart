import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddUser extends StatefulWidget {

  AddUser({Key? key, required this.id});
  final String id;



  @override
  State<AddUser> createState() => _AddUserState(this.id);
}

TextEditingController _referralController = TextEditingController();
TextEditingController _familydetailsController = TextEditingController();
TextEditingController _reasonreferralController = TextEditingController();
TextEditingController _complaintController = TextEditingController();
TextEditingController _historyController = TextEditingController();
TextEditingController _familyhistoryController = TextEditingController();
TextEditingController _observationController = TextEditingController();
TextEditingController _reccomendationController = TextEditingController();

class _AddUserState extends State<AddUser> {
  String id;

  _AddUserState(this.id);

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
                  TextField(
                    controller: _referralController,
                    decoration: const InputDecoration(hintText: "Refered By"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _familydetailsController,
                    decoration: const InputDecoration(hintText: "Family Details"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _reasonreferralController,
                    decoration: const InputDecoration(hintText: "Reason for Refered"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _complaintController,
                    decoration: const InputDecoration(hintText: "Present Complaints"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _historyController,
                    decoration: const InputDecoration(
                        hintText: "History for Metal or physical illness"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _familyhistoryController,
                    decoration: const InputDecoration(
                        hintText: "Family history for Mental illness"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),


                  TextField(
                    controller: _observationController,
                    decoration: const InputDecoration(
                        hintText: "Observation during history session"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _reccomendationController,
                    decoration: const InputDecoration(hintText: "Recomendations"),
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (validate()) {
                          addtofirebase(_referralController.text,
                              _familydetailsController.text,
                              _reasonreferralController.text,
                              _complaintController.text,
                              _historyController.text,
                              _familyhistoryController.text,
                              _observationController.text,
                              _reccomendationController.text,
                          );
                          _referralController.text="";
                          _familydetailsController.text="";
                          _reasonreferralController.text="";
                          _complaintController.text="";
                          _historyController.text="";
                          _familyhistoryController.text="";
                          _observationController.text="";
                          _reccomendationController.text="";

                          Navigator.pop(context);
                        }
                        //Fluttertoast.showToast(msg: id);
                      },
                      style: ElevatedButton.styleFrom(
                        //backgroundColor: Colors.black,
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

  addtofirebase(String referral, String familydetails, String reasonreferral, String complaint, String history, String familyhistory, String observation, String reccomendation) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({
      "referral": referral,
      "familydetails": familydetails,
      "reasonreferral": reasonreferral,
      "complaint": complaint,
      "history": history,
      "familyhistory": familyhistory,
      "observation": observation,
      "reccomendation": reccomendation
    });
  }

  bool validate() {
    if (_referralController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Referral cannot be empty");
      return false;
    }
    if (_familydetailsController.text.isEmpty) {
      Fluttertoast.showToast(msg: "family details cannot be empty");
      return false;
    }
    if (_reasonreferralController.text.isEmpty) {
      Fluttertoast.showToast(msg: "reason for referral cannot be empty");
      return false;
    }
    if (_complaintController.text.isEmpty) {
      Fluttertoast.showToast(msg: "complaint cannot be empty");
      return false;
    }
    if (_historyController.text.isEmpty) {
      Fluttertoast.showToast(msg: "history cannot be empty");
      return false;
    }
    if (_familyhistoryController.text.isEmpty) {
      Fluttertoast.showToast(msg: "family history cannot be empty");
      return false;
    }
    if (_observationController.text.isEmpty) {
      Fluttertoast.showToast(msg: "observation cannot be empty");
      return false;
    }
    if (_reccomendationController.text.isEmpty) {
      Fluttertoast.showToast(msg: "reccomendation cannot be empty");
      return false;
    }
    return true;
  }
}

