import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/order_model.dart';
class MyOrder extends StatefulWidget {
  const MyOrder({Key? key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Order"),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Orders').where("Uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data!.docs.map((doc) {
            return Order_Model.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
          }).toList();
          if (orders.isEmpty) {
            return const Center(child: Text("No orders found."));
          }
          return ListView.separated(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              var abc= index+1;
              return ListTile(
                title: Text('Order ID: ${order.orderid}'),
                subtitle: Text('Total Price: ${order.product_price}\n'
                    'Payment Method: ${order.Payment_Method}\n'
                    'User Name: ${order.user_name}\n'
                    'Products: ${order.product_name.join(", ")}'),
                leading: Text(abc.toString()),
              );
            }, separatorBuilder: (BuildContext context, int index) { return Divider(height: 3,); },
          );
        },
      ),
    );
  }
}
