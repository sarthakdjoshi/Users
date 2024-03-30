import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users/Model/order_model.dart';
import 'package:users/Model/product_model.dart';

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
                return FutureBuilder<Product_Model>(
                  future: _getProductData(order.product_name.first), // Assuming product_name contains only one product
                  builder: (context, AsyncSnapshot<Product_Model> productSnapshot) {
                    if (productSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (productSnapshot.hasError) {
                      return Text('Error: ${productSnapshot.error}');
                    }
                    final product = productSnapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(product.images[0],width: 200,height: 200,), // Display product image

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
                              order.product_name.join(", "),
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
              },
            );
          }
        },
      ),
    );
  }

  Future<Product_Model> _getProductData(String productName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Product").where("product_name", isEqualTo: productName).get();
    if (querySnapshot.docs.isNotEmpty) {
      return Product_Model.fromFirestore(querySnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>);
    } else {
      throw Exception("Product not found");
    }
  }
}
