import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users/Screen/checkout.dart';

import '../Model/Cart_Model.dart';
import 'Prodcut_detail.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

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

            // Calculate total price
            double totalPrice = 0;
            for (var cart in carts) {
              totalPrice +=
                  double.parse(cart.qty) * double.parse(cart.price_new);
            }

            return Column(
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
                                      Text(
                                        "Price: ${cart.price_new}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              var abc = int.parse(cart.qty);
                                              abc = abc - 1;
                                              if(abc==0){
                                                FirebaseFirestore.instance
                                                    .collection("Cart")
                                                    .doc(cart.id)
                                                    .delete();
                                              }
                                              FirebaseFirestore.instance
                                                  .collection("Cart")
                                                  .doc(cart.id)
                                                  .update({
                                                "qty": abc.toString(),
                                                "total": double.parse(cart.qty) *
                                                    double.parse(cart.price_new)
                                              });

                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.minimize),
                                          ),
                                          Text(
                                            "Qty: ${cart.qty.toString()}",
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              var abc = int.parse(cart.qty);
                                              abc = abc + 1;
                                              FirebaseFirestore.instance
                                                  .collection("Cart")
                                                  .doc(cart.id)
                                                  .update({
                                                "qty": abc.toString(),
                                                "total": double.parse(cart.qty) *
                                                    double.parse(cart.price_new)
                                              });

                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.add),
                                          ),

                                        ],

                                      ),
                                      Text(
                                        "Sub-total=${int.parse(cart.qty) * int.parse(cart.price_new)}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("Cart")
                                          .doc(cart.id)
                                          .delete()
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Removed from the cart"),
                                          ),
                                        );
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price: $totalPrice", // Display total price
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          (totalPrice==0)?ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No Item Added"),duration: Duration(seconds: 2),)):
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Checkout(),
                              ));
                        },
                        child: const Text("Checkout"),
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
