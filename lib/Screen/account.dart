import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Account extends StatefulWidget{
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: true,
        backgroundColor: Colors.indigo,

      ),
      body: Center(
        child: Text("Account"),
      ),
    );
  }
}