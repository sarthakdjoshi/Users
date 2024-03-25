import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/Cart_Model.dart';
import 'Address.dart';
import 'Prodcut_detail.dart';

class Checkout extends StatefulWidget {
  final String? productid;

  const Checkout({Key? key, this.productid}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _abcStream;

  @override
  void initState() {
    super.initState();
    if (widget.productid != null) {
      _abcStream = FirebaseFirestore.instance
          .collection("Cart")
          .where("pid", isEqualTo: widget.productid)
          .snapshots();
    } else {
      _abcStream = FirebaseFirestore.instance.collection("Cart").snapshots();
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
        stream: _abcStream,
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
            for (var cart in carts) {
              totalNewPrice +=
                  double.parse(cart.qty) * double.parse(cart.price_new);
            }
            double totalOldPrice = 0;
            for (var cart in carts) {
              totalOldPrice +=
                  double.parse(cart.qty) * double.parse(cart.price_old);
            }
            double total = totalOldPrice - totalNewPrice;
            double subtotal = totalNewPrice;
            if (subtotal < 10000) {
              subtotal += 50;
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
                                        Text(
                                          "MRP: ₹${cart.price_old}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationColor: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Qty: ${cart.qty.toString()}",
                                          style: const TextStyle(fontSize: 14),
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
                  child: Card(
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Price Detail",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildPriceDetailRow(
                                    "Product Price:",
                                    totalOldPrice.toString(),
                                  ),
                                  buildPriceDetailRow(
                                    "Total Discount:",
                                    total.toString(),
                                  ),
                                  buildPriceDetailRow(
                                    "Delivery Charge:",
                                    (totalNewPrice < 10000) ? "50.00" : "0.00",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Subtotal:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              subtotal.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ₹${subtotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Address(cartList: carts),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: const Text(
                              "Place order",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 15,
                              ),
                            ),
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

  Widget buildPriceDetailRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "₹$amount",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
