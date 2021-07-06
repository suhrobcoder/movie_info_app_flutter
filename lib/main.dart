import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_info_app_flutter/ui/screens/details/details_screen.dart';
import 'package:movie_info_app_flutter/ui/screens/home/home_screen.dart';
import 'package:movie_info_app_flutter/ui/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light),
    );
    return MaterialApp(
      title: 'Movie Info App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: HomeScreen(),
    );
  }
}
