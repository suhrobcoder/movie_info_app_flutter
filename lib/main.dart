import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_info_app_flutter/service_locator.dart';
import 'package:movie_info_app_flutter/ui/screens/home/home_screen.dart';
import 'package:movie_info_app_flutter/ui/theme/app_theme.dart';
import 'package:movie_info_app_flutter/ui/theme/colors.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: backgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      scrollBehavior: const CupertinoScrollBehavior(),
      title: 'Movie Info App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: HomeScreen.screen(),
    );
  }
}
