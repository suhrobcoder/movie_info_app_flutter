import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_info_app_flutter/service_locator.dart';
import 'package:movie_info_app_flutter/ui/screens/home/home_screen.dart';
import 'package:movie_info_app_flutter/ui/theme/app_theme.dart';

void main() {
  setup();
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
      home: HomeScreen.screen(),
    );
  }
}
