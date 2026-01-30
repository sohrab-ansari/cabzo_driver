import 'package:flutter/material.dart';

class Newwwwwwwwwwz extends StatefulWidget {
  const Newwwwwwwwwwz({super.key});

  @override
  State<Newwwwwwwwwwz> createState() => _NewwwwwwwwwwzState();
}

class _NewwwwwwwwwwzState extends State<Newwwwwwwwwwz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Screen"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 👈 pop back
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // 👈 pop back
          },
          child: const Text("Go Back"),
        ),
      ),
    );
  }
}