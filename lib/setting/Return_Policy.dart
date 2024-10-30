import 'package:flutter/material.dart';

class ReturnPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Return Policy"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Return Policy",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "We want you to be satisfied with your purchase. If you are not completely satisfied, you may return items for a full refund within 7 days of purchase, provided that the following conditions are met:\n\n"
              "1. The item must be in its original condition, unused, and in the same packaging as received.\n\n"
              "2. You must have proof of purchase, such as a receipt or order confirmation.\n\n"
              "3. Certain items, such as perishable goods, personalized items, and gift cards, are not eligible for return.\n\n"
              "4. Shipping and handling charges are non-refundable.\n\n"
              "5. You are responsible for return shipping costs, unless the return is due to our error.\n\n"
              "Please contact our customer service team at abc@gmail.com to initiate a return or if you have any questions.\n\n",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
