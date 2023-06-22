import 'package:flutter/material.dart';
import 'package:music_app/home/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'home/provider/home_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return ChangeNotifierProvider(
          create: (context) => HomeProvider(),
          child: Builder(builder: (context) {
            return MaterialApp(
              title: 'Music App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const HomePage(),
            );
          }));
    });
  }
}
