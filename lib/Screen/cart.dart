import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:users/Model/Cart_Model.dart';
import 'package:users/Screen/Prodcut_detail.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

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
            final List<Cart_Model> products = snapshot.data!.docs
                .map((doc) => Cart_Model.fromFirestore(doc))
                .toList();
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];

                return (product.uid ==
                    FirebaseAuth.instance.currentUser?.uid)
                    ? Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ProductDetail(productname: product.product_name),));
                    },
                    child: ListTile(
                      leading: Image.network(
                        product.images[0],
                        fit: BoxFit.cover,
                        width: 80,
                      ),
                      title: Text(
                        product.product_name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            "Price: ${product.price_new}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Qty: ${product.qty.toString()}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Cart")
                              .doc(product.id)
                              .delete()
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Removed from the cart"),
                              ),
                            );
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(); // Return an empty SizedBox for items that don't match the condition
              },
            );
          }
        },
      ),
    );
  }
}
