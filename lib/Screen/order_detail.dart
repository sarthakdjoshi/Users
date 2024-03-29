import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users/Model/order_model.dart';

class OrderDetail extends StatefulWidget {
  final String oid;

  const OrderDetail({super.key, required this.oid});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detail"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Orders")
            .where("orderid", isEqualTo: widget.oid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final List<Order_Model> orders = snapshot.data!.docs
                .map((doc) => Order_Model.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
                .toList();

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Order Detail:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: const Text(
                          "Product Name:",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                            (order.product_name).join(", ") ,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          "Product Price:",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                          order.product_price is List ? (order.product_price as List).join(", ") : order.product_price.toString(),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          "Payment Method:",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                          order.Payment_Method,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          "User Name:",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                          order.user_name,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          "Order Status:",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                          order.orderstatus,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      const Divider(height: 2, thickness: 2, color: Colors.indigo),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
