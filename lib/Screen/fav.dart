import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:users/Model/Fav_Model.dart';

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
        stream: FirebaseFirestore.instance.collection("Fav").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            final List<Fav_Model> products = snapshot.data!.docs
                .map((doc) => Fav_Model.fromFirestore(doc))
                .toList();
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];

                return (product.User_id ==
                        FirebaseAuth.instance.currentUser?.uid)
                    ? Card(
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                product.Product_Image[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.Product_Name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                              child: Text(
                                product.Product_Price,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, bottom: 8.0),
                                child: Column(
                                  children: [
                                    CupertinoButton(
                                        child: const Text("Remove From Fav"),
                                        onPressed: () {
                                          showDialog<void>(
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Are You Sure To Remove From Fav'),
                                                content: const Text('Remove?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(
                                                              dialogContext)
                                                          .pop(); // Dismiss alert dialog
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection("Fav")
                                                          .doc(product.id)
                                                          .delete()
                                                          .then((value) {
                                                        Navigator.of(
                                                                dialogContext)
                                                            .pop();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "Fav Remove Successfully")));
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                    CupertinoButton(
                                        child: const Text("Move To  Cart"),
                                        onPressed: () {
                                          showDialog<void>(
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Are You Sure To Move To Cart'),
                                                content: const Text('Moveve?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(
                                                              dialogContext)
                                                          .pop(); // Dismiss alert dialog
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection("Cart")
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.uid)
                                                          .set({
                                                        "User_id": FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid,
                                                        "Product_Price": product
                                                            .Product_Price,
                                                        "Product_Name": product
                                                            .Product_Name,
                                                        "Product_Image": product
                                                            .Product_Image,
                                                      }).then((value) {
                                                        Navigator.of(
                                                                dialogContext)
                                                            .pop();
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("Fav")
                                                            .doc(product.id)
                                                            .delete()
                                                            .then((value) => ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text("Cart Added"))));
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        })
                                  ],
                                )),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(
                        child: Center(child: Text("No Fav Added")),
                      );
              },
            );
          }
        },
      ),
    );
  }
}
