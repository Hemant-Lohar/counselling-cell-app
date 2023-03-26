import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/login/userModal.dart';
import 'package:counselling_cell_application/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

import '../../firebase_options.dart';
import 'loginPage.dart';

var gender = "Male";
var Class = "F.Y.B.Tech.";
var Division = "A";
var Dept = "Mechanical Engineering";
var _useremailController = TextEditingController();
var _passwordController = TextEditingController();
var _confirmPasswordController = TextEditingController();
var _usernamecontroller = TextEditingController();
var _useragecontroller = TextEditingController();
var _usermobilecontroller = TextEditingController();
var _userUrnController = TextEditingController();

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModal>(
        create: (context) => UserModal(), child: const RegisterPage());
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<UserModal>(
        builder: (context, modal, child) {
          switch (modal.activeIndex) {
            case 0:
              return const PersonalDetails();
            case 1:
              return const EducationDetails();
            case 2:
              return const UserDetails();

            default:
              return const PersonalDetails();
          }
        },
      ),
    );
  }
}

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String dropdownValue = "Male";
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          children: [
            Image.asset('assets/registertion.jpg', height: 250, width: 250),
            Center(
              child: DotStepper(
                activeStep: modal.activeIndex,
                dotCount: modal.totalIndex,
                shape: Shape.pipe,
                dotRadius: 20,
                spacing: 10,
                tappingEnabled: false,
                indicator: Indicator.worm,
                fixedDotDecoration:
                    const FixedDotDecoration(color: Palette.tileback),
                indicatorDecoration:
                    const IndicatorDecoration(color: Palette.primary),
              ),
            ),
            TextFormField(
              style: const TextStyle(fontSize: 14),
              controller: _usernamecontroller,
              decoration: const InputDecoration(
                  labelText: "Name", hintText: "Enter your full name"),
              validator: RequiredValidator(
                errorText: "Required",
              ),
            ),
            TextFormField(
              style: const TextStyle(fontSize: 14),
              controller: _useragecontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Age",
              ),
              validator: MultiValidator([
                RequiredValidator(errorText: "Required"),
                RangeValidator(min: 16, max: 90, errorText: "Invalid Age!")
              ]),
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(label: Text("Select Gender")),
              value: gender,
              hint: const Text("Select Gender"),
              icon: const Icon(Icons.arrow_downward),
              items: const [
                DropdownMenuItem(
                    value: "Male",
                    child: Text(
                      "Male",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "Female",
                    child: Text(
                      "Female",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "LGBTQ+",
                    child: Text(
                      "LGBTQ+",
                      style: TextStyle(fontSize: 14),
                    )),
              ],
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
                gender = dropdownValue;
              },
            ),
            // TextFormField(
            //   style: const TextStyle(fontSize: 14),
            //   controller: _Usergendercontroller,
            //   decoration: const InputDecoration(
            //     labelText: "Gender",
            //   ),
            //   validator: RequiredValidator(errorText: "Required"),
            // ),
            TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: _usermobilecontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Mobile",
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  LengthRangeValidator(
                      min: 10,
                      max: 10,
                      errorText: "Mobile number must be 10 digits"),
                  RangeValidator(min: 0, max: 9999999999, errorText: "Invalid number")
                ])),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  //next
                  modal.changeIndex(modal.activeIndex = 1);
                  modal.username = _usernamecontroller.text;
                  modal.userage = _useragecontroller.text;
                  modal.usergender = gender;
                  modal.usermobile = _usermobilecontroller.text;
                }
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: const StadiumBorder(),
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      );
    });
  }
}

class EducationDetails extends StatefulWidget {
  const EducationDetails({Key? key}) : super(key: key);

  @override
  State<EducationDetails> createState() => _EducationDetailsState();
}

class _EducationDetailsState extends State<EducationDetails> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String dropdownValueClass = Class;
  String dropdownValueDivision = Division;
  String dropdownValueDept = Dept;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          children: [
            Image.asset('assets/registertion.jpg', height: 250, width: 250),
            Center(
              child: DotStepper(
                activeStep: modal.activeIndex,
                dotCount: modal.totalIndex,
                shape: Shape.pipe,
                dotRadius: 20,
                spacing: 10,
                fixedDotDecoration:
                    const FixedDotDecoration(color: Palette.tileback),
                indicatorDecoration:
                    const IndicatorDecoration(color: Palette.primary),
              ),
            ),
            DropdownButtonFormField(
              decoration:
                  const InputDecoration(label: Text("Select Department")),
              value: Dept,
              hint: const Text("Select Department"),
              icon: const Icon(Icons.arrow_downward),
              items: const [
                DropdownMenuItem(
                    value: "Computer Science & Engineering",
                    child: Text(
                      "Computer Science & Engineering",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "Mechanical Engineering",
                    child: Text(
                      "Mechanical Engineering",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "Civil Engineering",
                    child: Text(
                      "Civil Engineering",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "Electrical Engineering",
                    child: Text(
                      "Electrical Engineering",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "Aeronautical Engineering",
                    child: Text(
                      "Aeronautical Engineering",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "Food Technology",
                    child: Text(
                      "Food Technology",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "AI & DS",
                    child: Text(
                      "AI & DS",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "IoT & Cyber Security",
                    child: Text(
                      "IoT & Cyber Security",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "Agriculture Engineering",
                    child: Text(
                      "Agriculture Engineering",
                      style: TextStyle(fontSize: 14),
                    )),
              ],
              onChanged: (String? value) {
                setState(() {
                  dropdownValueDept = value!;
                });
                Dept = dropdownValueDept;
              },
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(label: Text("Select Year")),
              value: Class,
              hint: const Text("Select Year"),
              icon: const Icon(Icons.arrow_downward),
              items: const [
                DropdownMenuItem(
                    value: "F.Y.B.Tech.",
                    child: Text(
                      "F.Y.B.Tech.",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "S.Y.B.Tech.",
                    child: Text(
                      "S.Y.B.Tech.",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "T.Y.B.Tech.",
                    child: Text(
                      "T.Y.B.Tech.",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "B.Tech.",
                    child: Text(
                      "B.Tech.",
                      style: TextStyle(fontSize: 14),
                    )),
              ],
              onChanged: (String? value) {
                setState(() {
                  dropdownValueClass = value!;
                });
                Class = dropdownValueClass;
              },
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(label: Text("Select Division")),
              value: Division,
              hint: const Text("Select Division"),
              icon: const Icon(Icons.arrow_downward),
              items: const [
                DropdownMenuItem(
                    value: "A",
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "B",
                    child: Text(
                      "B",
                      style: TextStyle(fontSize: 14),
                    )),
                DropdownMenuItem(
                    value: "C",
                    child: Text(
                      "C",
                      style: TextStyle(fontSize: 14),
                    )),
              ],
              onChanged: (String? value) {
                setState(() {
                  dropdownValueDivision = value!;
                });
                Division = dropdownValueDivision;
              },
            ),
            TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: _userUrnController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "URN",
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required"),
                  LengthRangeValidator(
                      min: 8, max: 8, errorText: "URN must be 8 digits"),
                  RangeValidator(min: 18000000, max: 23999999, errorText: "Invalid URN")
                ])),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //next
                    modal.changeIndex(modal.activeIndex - 1);
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Palette.secondary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      //next
                      modal.changeIndex(modal.activeIndex + 1);
                      modal.userclass = Class;
                      modal.userdivision = Division;
                      modal.userdepartment = Dept;
                      modal.urn = _userUrnController.text;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _useremailController.text = "";
    _passwordController.text = "";
    _confirmPasswordController.text = "";
    _usernamecontroller.text = "";
    _useragecontroller.text = "";
    _usermobilecontroller.text = "";
    _userUrnController.text = "";
    gender = "Male";
    Class = "F.Y.B.Tech.";
    Division = "A";
    Dept = "Mechanical Engineering";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          children: [
            Image.asset('assets/registertion.jpg', height: 250, width: 250),
            Center(
              child: DotStepper(
                activeStep: modal.activeIndex,
                dotCount: modal.totalIndex,
                shape: Shape.pipe,
                dotRadius: 20,
                spacing: 10,
                fixedDotDecoration:
                    const FixedDotDecoration(color: Palette.tileback),
                indicatorDecoration:
                    const IndicatorDecoration(color: Palette.primary),
              ),
            ),
            TextFormField(
              style: const TextStyle(fontSize: 14),
              controller: _useremailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            TextFormField(
              style: const TextStyle(fontSize: 14),
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            TextFormField(
              style: const TextStyle(fontSize: 14),
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //next
                    modal.changeIndex(modal.activeIndex - 1);
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Palette.secondary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      //next
                      // modal.changeIndex(modal.activeIndex + 1);
                      modal.useremail = _useremailController.text;

                      Firebase.initializeApp(
                          options: DefaultFirebaseOptions.currentPlatform);

                      final user = MyUser(
                          id: modal.useremail,
                          name: modal.username,
                          age: int.parse(modal.userage),
                          gender: modal.usergender,
                          mobile: int.parse(modal.usermobile),
                          uclass: modal.userclass,
                          department: modal.userdepartment,
                          division: modal.userdivision,
                          urn: modal.urn,
                          assessment: modal.assessment,
                          firstTime: modal.firstTime,
                          sessionCount: modal.sessionCount);

                      await signUp(_useremailController.text,
                              _passwordController.text)
                          .then((value) => {createUser(user)})
                          .then((value) => {
                                Navigator.popUntil(
                                  context,
                                  ModalRoute.withName('/'),
                                ),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                )
                              })
                          .then((value) => Navigator.pop(context, UserModal));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class MyUser {
  String id;
  final String name;
  final int age;
  final int mobile;
  final String gender;
  final String uclass;
  final String division;
  final String department;
  final String urn;
  final bool assessment;
  final bool firstTime;
  final int sessionCount;

  MyUser(
      {this.id = '',
      required this.name,
      required this.age,
      required this.gender,
      required this.mobile,
      required this.uclass,
      required this.department,
      required this.division,
      required this.urn,
      required this.assessment,
      required this.firstTime,
      required this.sessionCount});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'mobile': mobile,
        'class': uclass,
        'department': department,
        'division': division,
        'urn': urn,
        'assessment': assessment,
        'firstTime': firstTime,
        'sessionCount': sessionCount
      };
}

Future signUp(String email, String password) async {
  // showDialog(context: context, barrierDismissible: false,
  // builder: (context) => const Center(child: CircularProgressIndicator()));

  try {

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    log(e.toString());
    Fluttertoast.showToast(msg: "This email is already in use");
  }
}

Future createUser(MyUser user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
  user.id = docUser.id;

  final json = user.toJson();
  await docUser.set(json);
}

// Future createUser(User user) async {
//   final docUser = FirebaseFirestore.instance.collection('Users').doc()
// }

// class UserDetails extends StatefulWidget {
//   const UserDetails({Key? key}) : super(key: key);

//   @override
//   State<UserDetails> createState() => _UserDetailsState();
// }

// class _UserDetailsState extends State<UserDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserModal>(builder: (context, modal, child) {
//       return (SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(36.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 Image.asset('assets/registertion.jpg'),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: TextFormField(
// style: TextStyle(fontSize:14),
//                     controller: _useremailController,
//                     decoration: const InputDecoration(
//                         hintText: 'Enter Email Address',
//                         hintStyle: TextStyle(color: Colors.grey),
//                         enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey))),
//                     style: const TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
// style: TextStyle(fontSize:14),
//                   obscureText: true,
//                   controller: _passwordController,
//                   decoration: const InputDecoration(
//                       hintText: 'Enter Password',
//                       hintStyle: TextStyle(color: Colors.grey),
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Colors.grey))),
//                   style: const TextStyle(color: Colors.black),
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
// style: TextStyle(fontSize:14),
//                   obscureText: true,
//                   controller: _confirmPasswordController,
//                   decoration: const InputDecoration(
//                       hintText: 'Confirm Password',
//                       hintStyle: TextStyle(color: Colors.grey),
//                       enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Colors.grey))),
//                   style: const TextStyle(color: Colors.black),
//                 ),
//                 const SizedBox(height: 50),
//                 ElevatedButton(
//                     onPressed: () {
//                       Firebase.initializeApp(
//                           options: DefaultFirebaseOptions.currentPlatform);
//                       if (validate()) {
//                         FirebaseAuth.instance
//                             .createUserWithEmailAndPassword(
//                                 email: _useremailController.text.trim(),
//                                 password: _passwordController.text.trim())
//                             .then((value) => {
//                                   Fluttertoast.showToast(
//                                     msg: "Registered Successfully!", // message
//                                     toastLength: Toast.LENGTH_SHORT, // length
//                                     gravity: ToastGravity.CENTER,
//                                     timeInSecForIosWeb:
//                                         1, // location// duration
//                                   ),
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             const LoginPage()),
//                                   )
//                                 })
//                             .onError((error, stackTrace) => {
//                                   Fluttertoast.showToast(
//                                     msg: "Registration Failed!", // message
//                                     toastLength: Toast.LENGTH_SHORT, // length
//                                     gravity: ToastGravity.CENTER,
//                                     timeInSecForIosWeb:
//                                         1, // location// duration
//                                   )
//                                 });
//                       }

//                       // if (validate()) {
//                       //   Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(builder: (context) => LoginPage()),
//                       //   );
//                       // Fluttertoast.showToast(
//                       //   msg: "Registered Successfully!!", // message
//                       //   toastLength: Toast.LENGTH_SHORT, // length
//                       //   gravity: ToastGravity.CENTER,
//                       //   timeInSecForIosWeb: 1, // location// duration
//                       // );
//                       // }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.black,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40, vertical: 16),
//                       shape: const StadiumBorder(),
//                     ),
//                     child: const Text('Register')),
//                 const SizedBox(height: 30),
//                 InkWell(
//                   onTap: () {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//         builder: (context) => const LoginPage()),
//   );
// },
//                   child: const Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Text(
//                       "Already Registered? Login here",
//                       style: TextStyle(color: Colors.black),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ));
//     });
//   }
// }

// Validations

// bool validate() {
//   String patternUsername =
//       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
//   RegExp regexUsername = RegExp(patternUsername);
//   String patternPassword =
//       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//   RegExp regexPassword = RegExp(patternPassword);
//   if (!regexUsername.hasMatch(_useremailController.text)) {
//     Fluttertoast.showToast(
//       msg: "Invalid email id", // message
//       toastLength: Toast.LENGTH_SHORT, // length
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1, // location// duration
//     );
//     return false;
//   }
//   if (!regexPassword.hasMatch(_passwordController.text)) {
//     Fluttertoast.showToast(
//       msg: "Invalid password", // message
//       toastLength: Toast.LENGTH_SHORT, // length
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1, // location// duration
//     );
//     return false;
//   }
//   if (_passwordController.text != _confirmPasswordController.text) {
//     Fluttertoast.showToast(
//       msg: "Passwords do not match", // message
//       toastLength: Toast.LENGTH_SHORT, // length
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1, // location// duration
//     );
//     return false;
//   }

//   return true;
//   // Continue
// }
