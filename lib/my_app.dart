import 'package:flutter/material.dart';
import 'features/home/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'movie-ticket',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFFFFC107),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
