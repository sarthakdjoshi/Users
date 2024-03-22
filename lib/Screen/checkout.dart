import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:users/Model/Product_Model.dart';

import '../Model/Cart_Model.dart';
import 'Prodcut_detail.dart';

class Checkout extends StatefulWidget {
  final String ? productid;
  const Checkout({Key? key, this.productid}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  var abc= FirebaseFirestore.instance.collection("Cart").snapshots();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.productid!=null){
      abc=FirebaseFirestore.instance.collection("Cart").where("pid",isEqualTo: widget.productid).snapshots();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:abc,
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

            double totalNewPrice = 0;
            carts.forEach((cart) {
              totalNewPrice +=
                  double.parse(cart.qty) * double.parse(cart.price_new);
            });
            double totalOldPrice = 0;
            carts.forEach((cart) {
              totalOldPrice +=
                  double.parse(cart.qty) * double.parse(cart.price_old);
            });
            double total = 0;
            total=totalOldPrice-totalNewPrice;

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
                                ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
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
                                        totalNewPrice.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                       Text(
                                        total.toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                       Text(
                                        (totalNewPrice<10000)?"50.00":"0.00",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            const  Divider(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const Text("Subtotal:"),
                                  const SizedBox(
                                    width: 180,
                                  ),
                                  Text(totalNewPrice.toString()),
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
                        "Total: ₹${totalNewPrice.toStringAsFixed(2)}",
                        // Display total price
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                            child: const Text("Place Order",style: TextStyle(color: Colors.indigo,fontSize:15),),
                          ),
                        ),
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
