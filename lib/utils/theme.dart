import 'package:flutter/material.dart';

class MyTheme{
   static final lightTheme= ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade100,
          appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade100,iconTheme:const IconThemeData(color: Colors.black),titleTextStyle:const TextStyle(color: Colors.black87)),
          iconTheme:const  IconThemeData(color: Colors.black),
          colorScheme:const ColorScheme.light(),
     primaryColor: Colors.white,
       secondaryHeaderColor: Colors.black87

   );

   static final darkTheme= ThemeData(
     scaffoldBackgroundColor: Colors.grey.shade900,
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900,iconTheme:const IconThemeData(color: Colors.white)),
     iconTheme:const IconThemeData(color: Colors.white),
      colorScheme:const ColorScheme.dark(),
     primaryColor: Colors.black87,
     secondaryHeaderColor: Colors.white
   );


}