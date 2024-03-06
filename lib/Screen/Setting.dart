import 'package:flutter/material.dart';

class My_Setting extends StatefulWidget {
  const My_Setting({super.key});

  @override
  State<My_Setting> createState() => _My_SettingState();
}

class _My_SettingState extends State<My_Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Setting"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("My Setting"),
      ),
    );
  }
}