import 'package:flutter/material.dart';
import 'package:laba3/features/part1/part1.dart';
import 'package:laba3/features/part2/part2.dart';
import 'package:laba3/features/part3/part3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          PartItem(
            title: 'part1',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Part1Page(),
                ),
              );
            },
          ),
          PartItem(
            title: 'part2',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Part2Page(),
                ),
              );
            },
          ),
          PartItem(
            title: 'part3',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Part3Page(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PartItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const PartItem({required this.title, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(title),
    );
  }
}
