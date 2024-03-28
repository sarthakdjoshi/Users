import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:users/Screen/orderconfirm.dart';
import 'package:uuid/uuid.dart';

import '../Model/Cart_Model.dart';
import '../Model/address_Model.dart';

class InvoiceScreen extends StatefulWidget {
  final String add_id;
  final List<Cart_Model> cartList;

  const InvoiceScreen(
      {super.key, required this.add_id, required this.cartList});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final Razorpay _razorpay = Razorpay();
  String userContact = '';
  var name = "";
  var price = "";
  var id = "";
  var fname = "";
  var oid = const Uuid().v1() ;
  var uid=FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getUserContact();
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // First, add your code to save order details
    List<String> productNames = [];
    for (var cartItem in widget.cartList) {
      productNames.add(cartItem.product_name);
    }
    FirebaseFirestore.instance.collection("Orders").add({
      "Uid": FirebaseAuth.instance.currentUser!.uid,
      "product_name": productNames,
      "product_price": price,
      "user_name": fname,
      "Payment_Method": "online",
      "orderid": oid
    }).then((value) {
      // After saving order details, delete the cart items
      for (var cartItem in widget.cartList) {
        FirebaseFirestore.instance.collection("Cart")
           .where("Uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(oid: oid),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Successful')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete cart documents')),
      );
    });
  }






  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Failed')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  void openCheckout() {
    var options = {
      'key': 'rzp_test_nLQYAWuOKvzENb',
      'amount': calculateGrandTotal() * 100,
      'name': 'Unicorn',
      'description': "Payment of Your Order",
      'prefill': {
        'contact': userContact,
        'email': FirebaseAuth.instance.currentUser!.email.toString(),
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  double calculateGrandTotal() {
    double grandTotal = 0;
    for (var cart in widget.cartList) {
      grandTotal += double.parse(cart.price_new) * double.parse(cart.qty);
    }
    if (grandTotal < 10000) {
      grandTotal += 50;
    }
    return grandTotal;
  }

  void getUserContact() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Customeraddress')
        .where("Uid", isEqualTo: uid)
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      setState(() {
        userContact = userSnapshot.docs[0]['contact'];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Customeraddress")
            .where("add_id", isEqualTo: widget.add_id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            final List<Address_Model> addresses = snapshot.data!.docs
                .map((doc) => Address_Model.fromFirestore(doc))
                .toList();

            return ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                var address = addresses[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "User Address:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(address.fullname),
                    ),
                    ListTile(
                      title: Text(address.phoneno),
                    ),
                    ListTile(
                      title: Text(address.houseno),
                    ),
                    ListTile(
                      title: Text(address.roadname),
                    ),
                    ListTile(
                      title: Text(address.city),
                    ),
                    ListTile(
                      title: Text(address.state),
                    ),
                    ListTile(
                      title: Text(address.country),
                    ),
                    ListTile(
                      title: Text(address.pincode),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Order Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Column(
                      children: widget.cartList.map((cartItem) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(cartItem.product_name),
                            subtitle: Text(
                                "Price: ${cartItem.price_new}, Qty: ${cartItem.qty}"),
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Grand Total",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            " ₹${calculateGrandTotal().toString()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          fname=address.fullname;
                          widget.cartList.map((cartItem) {
                            name = cartItem.product_name;
                            price = calculateGrandTotal().toString();
                            id=cartItem.id;
                          }).toList();
                          // First, add your code to save order details
                          List<String> productNames = [];
                          for (var cartItem in widget.cartList) {
                            productNames.add(cartItem.product_name);
                          }
                          FirebaseFirestore.instance.collection("Orders").add({
                            "Uid": FirebaseAuth.instance.currentUser!.uid,
                            "product_name": productNames,
                            "product_price": price,
                            "user_name": fname,
                            "Payment_Method": "cod",
                            "orderid": oid
                          }).then((value) {
                            // After saving order details, delete the cart items
                            for (var cartItem in widget.cartList) {
                              FirebaseFirestore.instance.collection("Cart")
                                  .where("Uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                  .get()
                                  .then((querySnapshot) {
                                querySnapshot.docs.forEach((doc) {
                                  doc.reference.delete();
                                });
                              });
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmationScreen(oid: oid),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Payment Successful')),
                            );
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to delete cart documents')),
                            );
                          });
                        },
                        child: const Text(
                          "Cash on Delivery",
                          style: TextStyle(fontSize: 20, color: Colors.indigo),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          fname=address.fullname;
                          widget.cartList.map((cartItem) {
                            name = cartItem.product_name;
                            price = calculateGrandTotal().toString();
                            id=cartItem.id;
                          }).toList();
                          openCheckout();

                        },
                        child: const Text(
                          "Pay with Razorpay",
                          style: TextStyle(fontSize: 20, color: Colors.indigo),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
