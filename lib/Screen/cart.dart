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
            final List<Cart_Model> carts = snapshot.data!.docs
                .map((doc) => Cart_Model.fromFirestore(doc))
                .toList();
            return ListView.builder(
              itemCount: carts.length,
              itemBuilder: (context, index) {
                var cart = carts[index];

                return (cart.uid ==
                    FirebaseAuth.instance.currentUser?.uid)
                    ? Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>ProductDetail(productname: cart.product_name),));
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            "Price: ${cart.price_new}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Qty: ${cart.qty.toString()}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Sub-total=${cart.total.toString()}",style: TextStyle(fontSize: 15),),
                          IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("Cart")
                                  .doc(cart.id)
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
                        ],
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
