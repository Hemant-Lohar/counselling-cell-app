import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CdataClass extends ChangeNotifier{
  final username = FirebaseAuth.instance.currentUser!.email!;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}