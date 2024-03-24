import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/Cart_Model.dart';
import '../Model/address_Model.dart';
import 'address_new.dart';
import 'invoice.dart';

class Address extends StatefulWidget {
  final List<Cart_Model> cartList;

  const Address({Key? key, required this.cartList}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String _selectedAddressId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Address_New()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, size: 20, color: Colors.indigo),
                Text(
                  "Add New Address",
                  style: TextStyle(fontSize: 20, color: Colors.indigo),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Customeraddress")
                  .where("Uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  final List<Address_Model> addresses = snapshot.data!.docs
                      .map((doc) => Address_Model.fromFirestore(doc))
                      .toList();
                  return ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (BuildContext context, int index) {
                      var address = addresses[index];
                      return ListTile(
                        title: Text(address.fullname),
                        subtitle: Text(address.phoneno),
                        leading: Radio<String>(
                          value: address.add_id,
                          groupValue: _selectedAddressId,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedAddressId = value!;
                            });
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Visibility(
            visible: _selectedAddressId.isNotEmpty,
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoiceScreen(add_id: _selectedAddressId, cartList: widget.cartList),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.indigo, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

