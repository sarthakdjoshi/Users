import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Model/Cart_Model.dart';
import 'Prodcut_detail.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("Cart").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            final List<Cart_Model> carts = snapshot.data!.docs
                .map((doc) => Cart_Model.fromFirestore(doc))
                .toList();

            double totalPrice = 0;
            carts.forEach((cart) {
              totalPrice +=
                  double.parse(cart.qty) * double.parse(cart.price_new);
            });

            return Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: carts.length,
                          itemBuilder: (context, index) {
                            var cart = carts[index];
                            return (cart.uid ==
                                    FirebaseAuth.instance.currentUser?.uid)
                                ? Card(
                                    margin: const EdgeInsets.all(8),
                                    elevation: 4,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductDetail(
                                              productname: cart.product_name,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ListTile(
                                        leading: Image.network(
                                          cart.images[0],
                                          fit: BoxFit.cover,
                                          width: 80,
                                        ),
                                        title: Text(
                                          cart.product_name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            Column(
                                              children: [
                                                Text(
                                                  "MRP: ₹${cart.price_old}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationColor: Colors.red,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "Qty: ${cart.qty.toString()}",
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "Price: ₹${cart.price_new}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Card(
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Price Detail",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Column(
                                    children: [
                                      Text(
                                        "Product Price:",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "Total Discount:",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "Delivery Charge:",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 150,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        totalPrice.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const Text(
                                        "0.00",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const Text(
                                        "0.00",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text("Subtotal:"),
                                  SizedBox(
                                    width: 180,
                                  ),
                                  Text(totalPrice.toString()),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ₹${totalPrice.toStringAsFixed(2)}",
                        // Display total price
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement checkout functionality here
                        },
                        child: const Text("Place Order"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
