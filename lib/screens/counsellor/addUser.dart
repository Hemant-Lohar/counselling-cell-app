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
        title: const Text("Add a new user to database"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter first name"
              ),
              controller: _fnameController,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter last name"
              ),
              controller: _lnameController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Enter age"
              ),
              controller: _ageController,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: "specify gender"
              ),
              controller: _genderController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Enter URN"
              ),
              controller: _urnController,
            ),
            ElevatedButton(onPressed: (){
              final fname=_fnameController.text.toString();
              final lname = _lnameController.text.toString();
              final int age= int.parse(_ageController.text.toString());
              final gender = _genderController.text.toString();
              final int urn= int.parse(_urnController.text.toString());
              if(validate() ){
                addtofirebase(fname, lname, age, gender,urn);
                _fnameController.text="";
                _lnameController.text="";
                _ageController.text="";
                _genderController.text="";
                _urnController.text="";
                Navigator.pop(context);
              }


            }, child: const Text("Add User"))
          ],
        ),
      ),
    );
  }
  addtofirebase(String fname,String lname,int age,String gender, int urn) async {
    await FirebaseFirestore.instance.collection('users').doc(urn.toString()).set({"fname":fname,"lname":lname,"age":age,"gender":gender,"urn":urn});
  }

  bool validate() {
    if(_fnameController.text.isEmpty){
      Fluttertoast.showToast(msg: "First name cannot be empty");
      return false;
    }
    if(_lnameController.text.isEmpty){
      Fluttertoast.showToast(msg: "Last name cannot be empty");
      return false;
    }
    if(_ageController.text.isEmpty){
      Fluttertoast.showToast(msg: "Invalid age");
      return false;
    }
    if(_genderController.text.isEmpty){
      Fluttertoast.showToast(msg: "Invalid Gender");
      return false;
    }
    if(_urnController.text.isEmpty){
      Fluttertoast.showToast(msg: "Invalid URN");
      return false;
    }
    return true;
  }
}
