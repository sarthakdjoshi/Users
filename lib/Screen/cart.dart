import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:users/Model/Cart_Model.dart';

class Cart extends StatefulWidget {
  const Cart({super.key, Key? key});

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
            return ListView.separated(
              itemBuilder: (context, index) {
                var product = products[index];

                return (product.uid ==
                    FirebaseAuth.instance.currentUser?.uid)
                    ? ListTile(
                  leading: Image.network(
                    product.images[0],
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    product.product_name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    product.price_new,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Column(
                        children: [
                          Text("Qty=${product.qty.toString()}",style: const TextStyle(fontSize: 15),),
                          Text(product.total.toString(),style: const TextStyle(fontSize: 15),),

                        ],
                      ),
                      IconButton(onPressed: (){
                        FirebaseFirestore.instance.collection("Cart").doc(product.id).delete().then((value){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Removed from the cart")));
                        });
                      }, icon: const Icon(Icons.delete)),
                    ],
                  ),
                )
                    : const SizedBox.shrink(); // Return an empty SizedBox for items that don't match the condition
              },
              separatorBuilder: (context, index) => const Divider(), // Add a divider between list items
              itemCount: products.length,
            );
          }
        },
      ),
    );
  }
}
