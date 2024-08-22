import 'package:flutter/material.dart';

const TextStyle titleTextStyle = TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle bodyStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Color.fromARGB(255, 0, 0, 0),
);
const TextStyle bodyStyleDark = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Color.fromARGB(255, 255, 255, 255),
);

const TextStyle subtitles = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
const TextStyle subtitlesDark = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle userStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

InputDecoration emailInputDecoration = InputDecoration(
  labelText: 'Usuario',
  labelStyle: const TextStyle(color: Color.fromARGB(255, 47, 86, 163)),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 36, 65, 145),
      width: 2.0,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 36, 65, 145),
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 36, 65, 145),
      width: 2.0,
    ),
  ),
  filled: true,
  fillColor: Colors.white70,
);

InputDecoration passwordInputDecoration = InputDecoration(
  labelText: 'Contraseña',
  labelStyle: const TextStyle(color: Color.fromARGB(255, 47, 86, 163)),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 36, 65, 145),
      width: 2.0,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 36, 65, 145),
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 36, 65, 145),
      width: 2.0,
    ),
  ),
  filled: true,
  fillColor: Colors.white70,
);

const Color eyeIconColor = Color.fromARGB(255, 47, 86, 163);

const Color loginButtonBackgroundColor = Color.fromARGB(255, 47, 86, 163);
const Color loginButtonTextColor = Colors.white;
const TextStyle loginButtonTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const Color cardBackgroundColor = Color.fromARGB(255, 124, 45, 51);

//MAR//

const Color colorTextDark1 = Color.fromARGB(255, 151, 151, 151);
const Color colorTextDark2 = Color.fromARGB(255, 255, 255, 255);
const Color colorTextTabLighActive = Color.fromARGB(221, 40, 92, 223);
const Color colorTextTabDarkInactive = Color.fromARGB(255, 199, 199, 199);
const Color colorCardDark = Color.fromARGB(124, 49, 54, 63);
const Color colorDeleteNotifDark = Color(0xCFBF271D);
const Color primaryColorOrange = Color.fromARGB(255, 194, 70, 51);
const Color primaryColorBlue = Color(0xff2F63CE);
const Color NoticiaTitulo = Color.fromARGB(255, 21, 62, 164);
const Color colorCardDark2 = Color.fromARGB(255, 49, 54, 63);
const Color colorCardDark3 = Color.fromARGB(234, 41, 41, 41);
const Color colorCardLight2 = Color.fromARGB(255, 255, 255, 255);
const Color colorCardLight3 = Color.fromARGB(198, 255, 255, 255);
const Color colorTextLight = Colors.black;
