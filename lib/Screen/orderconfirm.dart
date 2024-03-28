import 'package:flutter/material.dart';
import 'package:users/Screen/order_detail.dart';

import 'bottomnavidate.dart';

class OrderConfirmationScreen extends StatelessWidget {
final String oid;
  const OrderConfirmationScreen({super.key, required this.oid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Order Confirmation'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 20),
              const  Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:  (context) => order_detail(oid: oid),));
              }, child: const Text("My Order Detail")),
              ElevatedButton(onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bottomnavigate(),));
              }, child: const Text("Continue Shoopping")),
            ],
          ),
        )
      ),
    );
  }
}

