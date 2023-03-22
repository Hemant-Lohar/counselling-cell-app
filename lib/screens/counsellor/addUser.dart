import 'package:counselling_cell_application/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key, required this.id}):super(key: key);
  final String id;

  @override
  State<AddUser> createState() => _AddUserState();
}

TextEditingController _referral              = TextEditingController();
TextEditingController _reasonReferral        = TextEditingController();
TextEditingController _parentMobile          = TextEditingController();
TextEditingController _informant             = TextEditingController();
TextEditingController _info                  = TextEditingController();
TextEditingController _complaint             = TextEditingController();
TextEditingController _familyHistory         = TextEditingController();
TextEditingController _parentDetails         = TextEditingController();
TextEditingController _siblings              = TextEditingController();
TextEditingController _birthOrder            = TextEditingController();
TextEditingController _pastmedicalHistory    = TextEditingController();
TextEditingController _medicalHistory        = TextEditingController();
TextEditingController _birthEarlyDevelopment = TextEditingController();
TextEditingController _childBehaviour        = TextEditingController();
TextEditingController _childIllness          = TextEditingController();
TextEditingController _menstrual             = TextEditingController();
TextEditingController _sexual                = TextEditingController();
TextEditingController _marital               = TextEditingController();
TextEditingController _alcohol               = TextEditingController();
TextEditingController _substance             = TextEditingController();
TextEditingController _ssc                   = TextEditingController();
TextEditingController _hscDiploma            = TextEditingController();
TextEditingController _entranceExam          = TextEditingController();
TextEditingController _cgpa                  = TextEditingController();
TextEditingController _extraInfo             = TextEditingController();
TextEditingController _assessment            = TextEditingController();
TextEditingController _observation           = TextEditingController();
TextEditingController _reccomendation        = TextEditingController();
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
        title: const Text("Case History Form", style: TextStyle(fontSize: 16),),
        leading: const BackButton(color: Colors.white),
        backgroundColor: Palette.secondary,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child:
          ListView(
            physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
              children: [
                const Center(child: Text("Basic Details"),),
                TextFormField(
                    controller: _referral,
                    decoration: const InputDecoration(hintText: "Referred By", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _reasonReferral,
                    decoration: const InputDecoration(hintText: "Reason for Referral", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _parentMobile ,
                    decoration: const InputDecoration(hintText: "Parent Mobile Number", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _informant ,
                    decoration: const InputDecoration(hintText: "Informant", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _info ,
                    decoration: const InputDecoration(hintText: "Information given by Parents/Teachers", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _complaint ,
                    decoration: const InputDecoration(hintText: "Chief complaints and History", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _familyHistory   ,
                    decoration: const InputDecoration(hintText: "Family History", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _parentDetails ,
                    decoration: const InputDecoration(hintText: "Parents Information", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _siblings  ,
                    decoration: const InputDecoration(hintText: "Siblings", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _birthOrder ,
                    decoration: const InputDecoration(hintText: "Birth Order", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _pastmedicalHistory,
                    decoration: const InputDecoration(hintText: "Past Medical & Psychiatric history", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _medicalHistory,
                    decoration: const InputDecoration(hintText: "Medical & Psychiatric History", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                const Center(child: Text("Personal History"),),
                TextFormField(
                    controller: _birthEarlyDevelopment,
                    decoration: const InputDecoration(hintText: "Birth and Early Development", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _childBehaviour  ,
                    decoration: const InputDecoration(hintText: "Behaviour during Childhood", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _childIllness ,
                    decoration: const InputDecoration(hintText: "Physical Illness during Childhood", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _menstrual  ,
                    decoration: const InputDecoration(hintText: "Menstrual History", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _sexual,
                    decoration: const InputDecoration(hintText: "Sexual History", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _marital              ,
                    decoration: const InputDecoration(hintText: "Marital History", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _alcohol              ,
                    decoration: const InputDecoration(hintText: "Use and abuse of alcohol", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _substance            ,
                    decoration: const InputDecoration(hintText: "tobacco and drugs abuse", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                const Center(child: Text("Educational History"),),
                TextFormField(
                    controller: _ssc,
                    decoration: const InputDecoration(hintText: "10th Marks", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _hscDiploma           ,
                    decoration: const InputDecoration(hintText: "12th/Diploma Marks", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _entranceExam         ,
                    decoration: const InputDecoration(hintText: "JEE/CET marks", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _cgpa                 ,
                    decoration: const InputDecoration(hintText: "Current Academic Performance", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _extraInfo            ,
                    decoration: const InputDecoration(hintText: "More info if any", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _assessment           ,
                    decoration: const InputDecoration(hintText: "Assessment (if any)", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _observation          ,
                    decoration: const InputDecoration(hintText: "Observation", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _reccomendation       ,
                    decoration: const InputDecoration(hintText: "Recommendation", hintStyle: TextStyle(fontSize: 14)),
                    maxLines: null,
                    validator: RequiredValidator(errorText: "Required")),
                const SizedBox(
                  height: 20,
                ),


                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false){
                        addtofirebase();
                        Navigator.pop(context);
                      }
                      Fluttertoast.showToast(msg: "Data added successfully");
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

  addtofirebase() async {
    DateTime dateTime=DateTime.now();
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      "referral": _referral.text,
      "reasonReferral": _reasonReferral.text,
      "parentMobile": _parentMobile.text,
      "informant": _informant.text,
      "info": _info.text,
      "complaint": _complaint.text,
      "familyHistory": _familyHistory.text,
      "parentDetails": _parentDetails.text,
      "siblings": _siblings.text,
      "birthOrder": _birthOrder.text,
      "pastmedicalHistory": _pastmedicalHistory.text,
      "medicalHistory": _medicalHistory.text,
      "birthEarlyDevelopment": _birthEarlyDevelopment.text,
      "childBehaviour": _childBehaviour.text,
      "childIllness": _childIllness.text,
      "menstrual": _menstrual.text,
      "sexual": _sexual.text,
      "marital": _marital.text,
      "alcohol": _alcohol.text,
      "substance": _substance.text,
      "ssc": _ssc.text,
      "hscDiploma": _hscDiploma.text,
      "entranceExam": _entranceExam.text,
      "cgpa": _cgpa.text,
      "extraInfo": _extraInfo.text,
      "assessment": _assessment.text,
      "observation": _observation.text,
      "reccomendation": _reccomendation.text,
      "doj": "${dateTime.day}/${dateTime.month}/${dateTime.year}",

    });
  }

  bool validate() {

    if( _referral.text.isEmpty       ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _reasonReferral.text.isEmpty ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _parentMobile.text.isEmpty   ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _informant.text.isEmpty      ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _info.text.isEmpty           ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _complaint.text.isEmpty      ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _familyHistory.text.isEmpty  ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _parentDetails.text.isEmpty  ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _siblings.text.isEmpty       ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _birthOrder.text.isEmpty     ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _pastmedicalHistory.text.isEmpty){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _medicalHistory.text.isEmpty ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _birthEarlyDevelopment.text.isEmpty){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _childBehaviour.text.isEmpty ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _childIllness.text.isEmpty  ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _menstrual.text.isEmpty      ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _sexual.text.isEmpty         ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _marital.text.isEmpty        ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _alcohol.text.isEmpty        ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _substance.text.isEmpty      ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _ssc.text.isEmpty            ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _hscDiploma.text.isEmpty     ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _entranceExam.text.isEmpty   ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _cgpa.text.isEmpty           ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _extraInfo.text.isEmpty      ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _assessment.text.isEmpty     ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _observation.text.isEmpty    ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    if( _reccomendation.text.isEmpty ){
      Fluttertoast.showToast(msg:"Field cannot be empty");
      return false;
    }
    return true;
  }
}
