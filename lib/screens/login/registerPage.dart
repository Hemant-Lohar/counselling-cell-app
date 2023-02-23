import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/screens/login/userModal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

import '../../firebase_options.dart';
import 'loginPage.dart';

var _useremailController = TextEditingController();
var _passwordController = TextEditingController();
var _confirmPasswordController = TextEditingController();
var _Usernamecontroller = TextEditingController();
var _Useragecontroller = TextEditingController();
var _Usergendercontroller = TextEditingController();
var _Usercontroller = TextEditingController();
var _Usermobilecontroller = TextEditingController();
var _Userdepartmentcontroller = TextEditingController();
var _Userclasscontroller = TextEditingController();
var _Userdivisioncontroller = TextEditingController();

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
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset('assets/register.png', height: 250, width: 250),
            Center(
              child: DotStepper(
                activeStep: modal.activeIndex,
                dotCount: modal.totalIndex,
                shape: Shape.pipe,
                dotRadius: 20,
                spacing: 10,
                tappingEnabled: false,
                indicator: Indicator.worm,
              ),
            ),
            TextFormField(
              controller: _Usernamecontroller,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            TextFormField(
              controller: _Useragecontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Age",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            TextFormField(
              controller: _Usergendercontroller,
              decoration: const InputDecoration(
                labelText: "Gender",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            TextFormField(
              controller: _Usermobilecontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Mobile",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  //next
                  modal.changeIndex(modal.activeIndex = 1);
                  modal.username = _Usernamecontroller.text;
                  modal.userage = _Useragecontroller.text;
                  modal.usergender = _Usergendercontroller.text;
                  modal.usermobile = _Usermobilecontroller.text;
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
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset('assets/register.png', height: 250, width: 250),
            Center(
              child: DotStepper(
                activeStep: modal.activeIndex,
                dotCount: modal.totalIndex,
                shape: Shape.pipe,
                dotRadius: 20,
                spacing: 10,
              ),
            ),
            TextFormField(
              controller: _Userclasscontroller,
              decoration: const InputDecoration(
                labelText: "Class",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            TextFormField(
              controller: _Userdepartmentcontroller,
              decoration: const InputDecoration(
                labelText: "Department",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            TextFormField(
              controller: _Userdivisioncontroller,
              decoration: const InputDecoration(
                labelText: "Division",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                //next
                modal.changeIndex(modal.activeIndex - 1);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: const StadiumBorder(),
              ),
              child: const Text('Back'),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  //next
                  modal.changeIndex(modal.activeIndex + 1);
                  modal.userclass = _Userclasscontroller.text;
                  modal.userdivision = _Userdivisioncontroller.text;
                  modal.userdepartment = _Userdepartmentcontroller.text;
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
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

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset('assets/register.png', height: 250, width: 250),
            Center(
              child: DotStepper(
                activeStep: modal.activeIndex,
                dotCount: modal.totalIndex,
                shape: Shape.pipe,
                dotRadius: 16,
                spacing: 10,
              ),
            ),
            TextFormField(
              controller: _useremailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              validator: RequiredValidator(errorText: "Required"),
            ),
            TextFormField(
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
            ElevatedButton(
              onPressed: () {
                //next
                modal.changeIndex(modal.activeIndex - 1);
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: const StadiumBorder(),
              ),
              child: const Text('Back'),
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
                      assessment: true
                  );

                  await signUp(
                          _useremailController.text, _passwordController.text)
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
                shadowColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: const StadiumBorder(),
              ),
              child: const Text('Register'),
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
  final bool assessment;

  MyUser({
    this.id = '',
    required this.name,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.uclass,
    required this.department,
    required this.division,
    required this.assessment
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'mobile': mobile,
        'class': uclass,
        'department': department,
        'division': division,
        'assessment': assessment
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
//                 Image.asset('assets/register.png'),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: TextFormField(
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
