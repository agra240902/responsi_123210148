import 'package:flutter/material.dart';
import 'package:agra_tpm/leagues_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leagues',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LeagueListPage(),
    );
  }
}
