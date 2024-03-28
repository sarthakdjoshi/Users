import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:users/Screen/order_detail.dart';
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
        title: const Text("My Orders"),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Orders')
            .where("Uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data!.docs
              .map((doc) => Order_Model.fromFirestore(
                  doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();
          if (orders.isEmpty) {
            return Center(child: Text("No orders found."));
          }
          return ListView.separated(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              var abc = index + 1;
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => order_detail(oid: order.orderid),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text('Order ID: ${order.orderid}'),
                    subtitle: Text(
                      'Total Price: ${order.product_price}\n'
                      'Payment Method: ${order.Payment_Method}\n'
                      'User Name: ${order.user_name}\n'
                      'Products: ${order.product_name.join(", ")}',
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Text(
                        abc.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 0),
          );
        },
      ),
    );
  }
}
