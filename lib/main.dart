import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const CanchaApp());
}

class CanchaApp extends StatelessWidget {
  const CanchaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cancha",
      home: CanchaLoginPage(),
    );
  }
}
