import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users/Model/order_model.dart';

class order_detail extends StatefulWidget {
  final String oid;

  const order_detail({super.key, required this.oid});

  @override
  State<order_detail> createState() => _order_detailState();
}

class _order_detailState extends State<order_detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Orders")
            .where("orderid", isEqualTo: widget.oid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            final List<Order_Model> orders = snapshot.data!.docs
                .map((doc) => Order_Model.fromFirestore(doc))
                .toList();

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Order Detail:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text("Product Name: ${order.product_name}"),
                    ),
                    ListTile(
                      title: Text("Product Price: ${order.product_price}"),
                    ),
                    ListTile(
                      title: Text("Order ID: ${order.orderid}"),
                    ),
                    ListTile(
                      title: Text("Payment Method: ${order.Payment_Method}"),
                    ),
                    ListTile(
                      title: Text("User Name: ${order.user_name}"),
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
