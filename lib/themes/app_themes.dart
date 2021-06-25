import 'package:flutter/material.dart';

class AppThemes {
  static final Color listNotReadBgColor = Color(0xffe5e7e8);
  static final Color listReadBgColor = Color(0xffffffff);
  static final Color lightDividerColor = Color(0xffe5e7e8);
  static final Color darkDividerColor = Color(0xffffffff);

static final appThemeData = {
    AppTheme.lightTheme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.blue,
      backgroundColor: Colors.white,
      selectedRowColor: listReadBgColor,
      unselectedWidgetColor: listNotReadBgColor,
      dividerColor: lightDividerColor,
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
      selectedRowColor: listReadBgColor,
      unselectedWidgetColor: listNotReadBgColor,
      dividerColor: darkDividerColor,
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
