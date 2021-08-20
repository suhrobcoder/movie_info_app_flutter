import 'package:flutter/material.dart';

import 'colors.dart';

var appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      primaryVariant: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
      onBackground: textColor),
  fontFamily: "SFPro",
);
