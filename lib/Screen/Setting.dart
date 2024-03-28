import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider.dart';

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
      body:  InkWell(
        onTap: () {
          Provider.of<ThemeProvider>(context, listen: false)
              .toggleTheme();
        },
        child: const ListTile(
          title: Text("Theme"),
          leading: Icon(Icons.nightlight),
        ),
      ),
    );
  }
}
