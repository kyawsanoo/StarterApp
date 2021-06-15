import 'package:flutter/material.dart';

class AppThemes {

static final appThemeData = {
    AppTheme.lightTheme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.blue,
      backgroundColor: Colors.white,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: Colors.black54,
        ),
        bodyText2: TextStyle(
          color: Colors.blueGrey,
        ),

      ),

    ),

    AppTheme.darkTheme: ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primarySwatch: Colors.teal,
      backgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: Colors.white,
        ),
        bodyText2: TextStyle(
          color: Colors.blueGrey,
        ),
      ),

    )
  };
}

enum AppTheme {
  lightTheme,
  darkTheme,
}
