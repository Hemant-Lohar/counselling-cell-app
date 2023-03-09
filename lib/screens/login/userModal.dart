
import 'package:flutter/foundation.dart';

class UserModal extends ChangeNotifier {
  String username = "";
  String useremail = "";
  String userdepartment ="";
  String userclass = "";
  String userdivision = "";
  String urn = "";
  String userage = "";
  String usermobile = "";
  String usergender ="";
  bool assessment=true;
  bool firstTime = true;
  int sessionCount=0;
  int activeIndex = 0;
  int totalIndex = 3;

  changeIndex(int index) {
    activeIndex = index;
    notifyListeners();
  }
  // saveUsername(String name) {
  //   username = name;
  //   notifyListeners();
  // }
  // saveuserage(String age) {
  //   userage = age;
  //   notifyListeners();
  // }
  // savegender(String gender) {
  //   usergender = gender;
  //   notifyListeners();
  // }
  // savemobile(String mobile) {
  //   usermobile = mobile;
  //   notifyListeners();
  // }
 
}
