import 'package:flutter/material.dart';

class SafariOwner extends StatelessWidget {
  const SafariOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("Safari Owner"),
      ),
      body: const Center(
        child: Text(
          "Hello World",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
