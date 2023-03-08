import 'package:counselling_cell_application/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key, required this.id}):super(key: key);
  final String id;

  @override
  State<AddUser> createState() => _AddUserState();
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
  String id="";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    id=widget.id;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Case History", style: TextStyle(fontSize: 16),),
        leading: const BackButton(color: Colors.white),
        backgroundColor: Palette.secondary,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: ListView(
            children: [
              TextFormField(
                  controller: _referralController,
                  decoration: const InputDecoration(hintText: "Refered By", hintStyle: TextStyle(fontSize: 14)),
                  maxLines: null,
                  validator: RequiredValidator(errorText: "Required")),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: _familydetailsController,
                  decoration: const InputDecoration(hintText: "Family Details", hintStyle: TextStyle(fontSize: 14)),
                  maxLines: null,
                  validator: RequiredValidator(errorText: "Required")),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: _reasonreferralController,
                  decoration:
                      const InputDecoration(hintText: "Reason for Refered", hintStyle: TextStyle(fontSize: 14)),
                  maxLines: null,
                  validator: RequiredValidator(errorText: "Required")),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: _complaintController,
                  decoration:
                      const InputDecoration(hintText: "Present Complaints", hintStyle: TextStyle(fontSize: 14)),
                  maxLines: null,
                  validator: RequiredValidator(errorText: "Required")),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: _historyController,
                  decoration: const InputDecoration(
                      hintText: "History for Mental or physical illness", hintStyle: TextStyle(fontSize: 14)),
                  maxLines: null,
                  validator: RequiredValidator(errorText: "Required")),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: _familyhistoryController,
                  decoration: const InputDecoration(
                      hintText: "Family history for Mental illness", hintStyle: TextStyle(fontSize: 14)),
                  maxLines: null,
                  validator: RequiredValidator(errorText: "Required")),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: _observationController,
                  decoration: const InputDecoration(
                      hintText: "Observation during history session", hintStyle: TextStyle(fontSize: 14)),
                  maxLines: null,
                  validator: RequiredValidator(errorText: "Required")),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: _reccomendationController,
                  decoration: const InputDecoration(hintText: "Recommendations", hintStyle: TextStyle(fontSize: 14)),
                  maxLines: null,
                  validator: RequiredValidator(errorText: "Required")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      addtofirebase(
                        _referralController.text,
                        _familydetailsController.text,
                        _reasonreferralController.text,
                        _complaintController.text,
                        _historyController.text,
                        _familyhistoryController.text,
                        _observationController.text,
                        _reccomendationController.text,
                      );
                      _referralController.text = "";
                      _familydetailsController.text = "";
                      _reasonreferralController.text = "";
                      _complaintController.text = "";
                      _historyController.text = "";
                      _familyhistoryController.text = "";
                      _observationController.text = "";
                      _reccomendationController.text = "";

                      Navigator.pop(context);
                    }
                    //Fluttertoast.showToast(msg: id);
                  },
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text("Add Details" , style: TextStyle(fontSize: 14))),
              const SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }

  addtofirebase(String referral,String familydetails,String reasonreferral,String complaint,
      String history,String familyhistory,String observation,String reccomendation) async {
    DateTime dateTime=DateTime.now();
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      "referral": referral,
      "familydetails": familydetails,
      "reasonreferral": reasonreferral,
      "complaint": complaint,
      "history": history,
      "familyhistory": familyhistory,
      "observation": observation,
      "reccomendation": reccomendation,
      "doj": "${dateTime.day}/${dateTime.month}/${dateTime.year}",

    });
  }

  // bool validate() {
  //   if (_referralController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: "Referral cannot be empty");
  //     return false;
  //   }
  //   if (_familydetailsController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: "family details cannot be empty");
  //     return false;
  //   }
  //   if (_reasonreferralController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: "reason for referral cannot be empty");
  //     return false;
  //   }
  //   if (_complaintController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: "complaint cannot be empty");
  //     return false;
  //   }
  //   if (_historyController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: "history cannot be empty");
  //     return false;
  //   }
  //   if (_familyhistoryController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: "family history cannot be empty");
  //     return false;
  //   }
  //   if (_observationController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: "observation cannot be empty");
  //     return false;
  //   }
  //   if (_reccomendationController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: "reccomendation cannot be empty");
  //     return false;
  //   }
  //   return true;
  // }
}
