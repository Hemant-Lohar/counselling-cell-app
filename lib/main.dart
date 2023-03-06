import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/theme/Palette.dart';
import 'DataClass.dart';
import 'screens/counsellor/counsellorPage.dart';
import 'screens/user/userPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/login/loginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => DataClass()),
      child: MaterialApp(
        title: 'Counselling Cell App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Palette.primary,
          // primaryColor: Palette.primary,
          fontFamily: 'Poppins',
          textTheme: const TextTheme(
            titleLarge: TextStyle(color: Colors.black),
            titleMedium: TextStyle(color: Colors.black),
            bodySmall: TextStyle(color: Colors.black),
            labelSmall: TextStyle(color: Colors.black),
          ),
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.email.toString() == "counsellor@gmail.com"
                  ? const CounsellorPage()
                  : const UserPage();
            } else {
              return const LoginPage();
            }
          },
        ),
      );
}
