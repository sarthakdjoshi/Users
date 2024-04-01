import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:users/Model/Saved_Address_Model.dart';

class Saved_Address extends StatefulWidget{
  @override
  State<Saved_Address> createState() => _Saved_AddressState();
}

class _Saved_AddressState extends State<Saved_Address> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Address"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("Customeraddress").where("Uid",isEqualTo:FirebaseAuth.instance.currentUser!.uid ).get(),
          builder:  (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return const CircularProgressIndicator();
            }
            if(snapshot.hasError){
              return  Text(snapshot.hasError.toString());
            }
              final address =snapshot.data!.docs.map((doc) {
                return Saved_Address_Model.fromFirestore(doc);
              }).toList();
            return ListView.builder(itemCount: address.length,itemBuilder: (context, index) {
              var add=address[index];
              var ci=++index;
             return Card(
               elevation: 4,
               margin: EdgeInsets.all(8),
               child: ListTile(
                 title: Text(add.fullname),
                 subtitle: Text(
                   '${add.houseno}, ${add.roadname}, ${add.city}, ${add.state}, ${add.pincode}',
                 ),
                 leading: CircleAvatar(child: Text(ci.toString()),),
                 trailing: Icon(Icons.location_on),
               ),
             );
            },);
          },),
    );
  }
}