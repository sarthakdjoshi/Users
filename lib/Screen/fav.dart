import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:users/Model/Favorites_Model.dart';
import 'package:users/Screen/Prodcut_detail.dart';

class Fav extends StatefulWidget {
  const Fav({super.key});

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  var id = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("Favorites").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            final List<Favorites_Model> products = snapshot.data!.docs
                .map((doc) => Favorites_Model.fromFirestore(doc))
                .toList();
            return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var product = products[index];

                return (product.uid == FirebaseAuth.instance.currentUser?.uid)
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                productname: product.product_name,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            color: Colors.blueGrey,
                            child: ListTile(
                              leading: Image.network(
                                product.images[0],
                              ),
                              title: Text(
                                product.product_name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    product.price_new,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    product.price_old,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.red),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("Favorites")
                                          .doc(product.id)
                                          .delete()
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Fav Removed Successfully"),
                                          ),
                                        );
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("Cart")
                                          .doc(product.id)
                                          .set({
                                        "images": product.images,
                                        "price_new": product.price_new,
                                        "price_old": product.price_old,
                                        "product_name": product.product_name,
                                        "qty": product.qty,
                                        "Uid": FirebaseAuth
                                            .instance.currentUser?.uid
                                            .toString(),
                                        "total": product.total,
                                        "pid": product.id
                                      }).then((value) {
                                        FirebaseFirestore.instance
                                            .collection("Product")
                                            .doc(product.id)
                                            .update({"fav": "no"});
                                        FirebaseFirestore.instance
                                            .collection("Favorites")
                                            .doc(product.id)
                                            .delete();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Added to the Cart Successfully"),
                                          ),
                                        );
                                      });
                                    },
                                    icon: const Icon(Icons.shopping_cart),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
              separatorBuilder: (context, index) => const Divider(height: 10),
              itemCount: products.length,
            );
          }
        },
      ),
    );
  }
}
