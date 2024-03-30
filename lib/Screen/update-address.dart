import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Appcolor.dart';

class Update_Address extends StatefulWidget {
  final String? uid;

  const Update_Address({super.key, required this.uid});

  @override
  State<Update_Address> createState() => _Update_AddressState();
}

class _Update_AddressState extends State<Update_Address> {
  var str1 = TextEditingController();
  var str2 = TextEditingController();
  var landmark = TextEditingController();
  var pincode = TextEditingController();

  Future<void> add() async {
    FirebaseFirestore.instance.collection("User").doc(widget.uid).set({
      "street1": str1.text.trim().toString(),
      "street2": str2.text.trim().toString(),
      "landmark": landmark.text.trim().toString(),
      "pincode": pincode.text.trim().toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
        centerTitle: true,
        backgroundColor:AppColors.lightBlue,
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: str1,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_city),
              hintText: "Street-1",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: str2,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_city),
              hintText: "Street-2",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: landmark,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_city),
              hintText: "landmark",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: pincode,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_city),
              hintText: "pincode",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                add();
              },
              child: const Text("Save Address"))
        ],
      ),
    );
  }
}
