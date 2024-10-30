import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users/Screen/order_detail.dart';

import '../Appcolor.dart';
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
        backgroundColor: AppColors.lightBlue, // Change app bar color
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Orders')
            .where("Uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data!.docs.map((doc) {
            return Order_Model.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>);
          }).toList();
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
                        builder: (context) => OrderDetail(oid: order.orderid),
                      ));
                },
                child: ListTile(
                  title: Text('Order ID: ${order.orderid}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Products: ${order.product_name.join(", ")}',
                      style: TextStyle(fontSize: 16)),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    // Change leading icon background color
                    child: Text(abc.toString(),
                        style: TextStyle(
                            color: Colors
                                .white)), // Change leading icon text color
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                  height: 3, color: Colors.grey); // Change divider color
            },
          );
        },
      ),
    );
  }
}
