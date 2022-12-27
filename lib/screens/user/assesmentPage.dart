import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AssesmentPage extends StatefulWidget {
  const AssesmentPage({super.key});

  @override
  State<AssesmentPage> createState() => _AssementPageState();
}

class _AssementPageState extends State<AssesmentPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Asesment"),
    );
  }
}
