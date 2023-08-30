import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  //앱 전체 테마 설정
  fontFamily: 'GmarketSansTTF',
  brightness: Brightness.light,
  // 밝기 여부
  primaryColor: Color(0xFF29BFFF),
  // 강조색
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
  // 플로팅 버튼 배경색
);