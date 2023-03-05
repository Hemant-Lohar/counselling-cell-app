import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor primary = MaterialColor(
    // 0xff7E9DFE, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    0xff1E39BC, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff718de5), //10%
      100: Color(0xff657ecb), //20%
      200: Color(0xff586eb2), //30%
      300: Color(0xff4c5e98), //40%
      400: Color(0xff4c5e98), //50%
      500: Color(0xff3f4f7f), //60%
      600: Color(0xff262f4c), //70%
      700: Color(0xff2e130e), //80%
      800: Color(0xff0d1019), //90%
      900: Color(0xff000000), //100%
    },
  );
  static const MaterialColor secondary = MaterialColor(
    // 0xffC1CDF3, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    // 0xff5976DA,
     0xff7E9DFE,
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffD5E4FF), //10%
    },
  );
  static const MaterialColor tileback = MaterialColor(
    0xffDCE8FF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffDCE8FF), //10%
    },
  );
  static const MaterialColor ternary = MaterialColor(
    0xffe64425, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xfffdece9), //10%
      100: Color(0xfffadad3), //20%
      200: Color(0xfff8c7be), //30%
      300: Color(0xfff5b4a8), //40%
      400: Color(0xfff3a292), //50%
      500: Color(0xfff08f7c), //60%
      600: Color(0xffee7c66), //70%
      700: Color(0xffeb6951), //80%
      800: Color(0xffe9573b), //90%
      900: Color(0xffe64425), //100%
    },
  );
}
