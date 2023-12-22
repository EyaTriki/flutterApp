import 'package:app/pages/login_page.dart';
import 'package:app/pages/register_page.dart';
import 'package:app/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    debugShowCheckedModeBanner: false,
  home: LoginOrRegister(),
   );
  }
}
