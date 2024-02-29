import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Cart extends StatefulWidget{
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
        backgroundColor: Colors.indigo,

      ),
      body: Center(
        child: Text("Cart"),
      ),
    );
  }
}